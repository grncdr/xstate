module XState
  class Interpreter
    def initialize(machine, state, side_effects)
      @machine = machine
      @state = state
      @side_effects = side_effects
    end

    attr_reader :state

    def send_event(event)
      next_state = @machine.transition(@state, event)
      next_state.actions.each do |action|
        @side_effects.dispatch_action(action, @state.context, event)
      end
      @state = next_state
      @state.value
    end
  end
end