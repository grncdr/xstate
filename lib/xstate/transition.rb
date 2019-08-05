module XState
  class TargetList
    def initialize(src_node, candidates)
      @candidates = Array(candidates).map { |c| Transition.new(src_node, c) }
    end

    attr_reader :candidates

    def find_transition(event, &dispatch_guard)
      @candidates.find { |c| c.allowed_by_guard?(event, &dispatch_guard) }
    end

    private

    class Transition
      def initialize(src_node, spec)
        @src_node = src_node
        if spec.is_a?(String)
          @key = spec
          @guard = nil
          @actions = []
        else
          @key = (spec[:target] || spec['target']) or raise "Transition spec contains no target #{spec.inspect}"
          @guard = spec[:cond] || spec['cond']
          @actions = spec[:actions] || spec['actions']
        end
      end

      attr_reader :key, :node

      def allowed_by_guard?(event)
        @guard.nil? || yield(@guard, event)
      end

      def actions
        @actions || []
      end

      def resolve!
        @node = @src_node.find_node(@key) or raise "Could not resolve target node #{@key} from #{@src_node.key}"
        while @node.is_a?(CompoundStateNode)
          @node = @node.initial
        end
      end

      # def pretty_print(pp)
      #   %[key guard, actions].each do |ivar|
      #     pp.text("@#{ivar}=")
      #     pp.breakable
      #     pp.pp(instance_variable_get("@#{ivar}"))
      #   end
      # end
    end
  end
end