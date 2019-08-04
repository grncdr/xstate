module XState
  Interpreter = Struct.new(:machine, :state, :side_effects) do
    def send_event(event)
      next_state = machine.transition(state, event)
      next_state.actions.each do |action|
        side_effects.dispatch_action(action, @state.context, event)
      end
      self.state = next_state
      self.state.value
    end
  end
end