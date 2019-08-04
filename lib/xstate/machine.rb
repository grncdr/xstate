
module XState
  class Machine
    def initialize(params, side_effects = SideEffects::Noop)
      @machine_id = params.delete(:id) || params.delete('id')
      @context = params.delete(:context) || params.delete('context')
      @root_node = StateNode.new(params)
    end

    attr_reader :machine_id, :context

    def initial
      State.new(@root_node.initial, {}, [], nil)
    end

    def with_side_effects(side_effects)
      clone.tap do |machine|
        machine.instance_eval { @side_effects = side_effects }
      end
    end

    def transition(current_state, event)
      event = Event.from_unknown(event)
      active_nodes = current_state.send(:nodes)
      raise "#{current_state.value.inspect} is final" if active_nodes.all? { |node| node.is_a?(FinalStateNode) }
      transitions = active_nodes.map { |node| node.find_transition(event) }
      raise "No transitions for event #{event.type} in state #{current_state.value.inspect}" if transitions.all?(&:nil?)
      actions = []
      next_nodes = []
      active_nodes.zip(transitions) do |node, transition|
        if transition
          binding.pry if transition.node.nil?
          next_nodes << transition.node
          actions.concat(transition.actions)
        else
          next_nodes << node
        end
      end
      State.new(next_nodes, @context, actions, current_state)
    end

    def interpreter(initial_state = self.initial, side_effects = SideEffects::Noop)
      Interpreter.new(self, initial_state, side_effects)
    end

    private

    def find_node(state, current_node = @states)
      if state.value.is_a?(Symbol) 
        current_node[state.value]
      end
    end
  end
end
