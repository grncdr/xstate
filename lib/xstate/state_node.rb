module XState
  class StateNode
    def self.new(params, parent = nil, key = nil)
      type = params[:type] || (params[:states] ? 'compound' : params[:on].nil? || params[:on].empty? ? 'final' : 'atomic')
      binding.pry if type == 'compound' && key == 'expected'
      klass = [AtomicStateNode, FinalStateNode, CompoundStateNode, ParallelStateNode, HistoryStateNode].find { |k| k.name[8 .. -10].downcase == type }
      raise "Unknown state node type: #{type.inspect}" if klass.nil?
      node = klass.allocate
      node.send(:initialize, params, parent, key)
      node
    end

    def initialize(params, parent, key)
      @parent = parent
      @key = key
      @transitions = {}
      (params[:on] || params['on'] || {}).each do |event_type, target|
        @transitions[event_type.to_s] = TargetList.new(self, target)
      end
      after_initialize(params)
      validate_transitions! if parent.nil?
    end

    attr_reader :parent, :key, :resolve

    def root
      parent ? parent.root : self
    end

    def parents
      current = self
      parents = []
      while parent = current.parent
        parents << parent
        current = parent
      end
      parents
    end

    def value
      parents.inject(key) { |last_key, parent| parent.key ? { parent.key => last_key } : last_key }
    end

    def find_node(key)
      raise "#{self.class.name}#find_node not implemented"
    end

    def find_transition(event)
      if target_list = @transitions[event.type]
        target_list.find_transition(event)
      elsif parent
        parent.find_transition(event)
      end
    end

    def validate_transitions!
      @transitions.each do |event, target|
        target.candidates.each(&:resolve!)
      end
    end

    protected

    def after_initialize(params); end
  end

  module ParentNode
    def find_node(key)
      @states[key] || (parent ? parent.find_node(key) : nil)
    end

    def states
      @states
    end

    def validate_transitions!
      super
      states.each_value(&:validate_transitions!)
    end

    protected

    def add_substates(params)
      @states = {}
      state_specs = params[:states] || params['states'] || {}
      state_specs.each do |ss_key, ss_params|
        ss_key = ss_key.to_s
        @states[ss_key] = StateNode.new(ss_params, self, ss_key)
      end
    end

  end

  module LeafNode
    def initial
      self
    end

    def find_node(key)
      parent.find_node(key)
    end
  end

  class CompoundStateNode < StateNode
    include ParentNode

    def after_initialize(params)
      add_substates(params)
      @initial = find_node((params['initial'] || params[:initial]).to_s)
    end

    attr_reader :initial
  end

  class ParallelStateNode < StateNode
    include ParentNode

    def after_initialize(params)
      add_substates(params)
    end

    def initial
      @states.map { |_, state| state.initial }
    end
  end

  class AtomicStateNode < StateNode
    include LeafNode
  end

  class FinalStateNode < StateNode
    include LeafNode

    def validate_transitions!; end

    def initial
      self
    end
  end

  class HistoryStateNode < StateNode; end

end