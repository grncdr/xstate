module XState
  module SideEffects
    class Noop
      def dispatch_guard(guard, event, context); end
      def dispatch_action(action, event, context); end
    end

    class Debug
      def dispatch_guard(guard, event, context)
      end

      def dispatch_action(action, event, context)
        puts "dispatch_action #{action} for #{event.type}"
      end
    end
  end
end