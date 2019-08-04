require 'forwardable'

module MachineHelper
  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    def machine=(machine)
      machine = XState::Machine.new(machine) unless machine.is_a?(XState::Machine)
      let(:machine) { machine }
    end
  end

  def interpreter
    @interpreter ||= machine.interpreter
  end

  def send_event(event)
    interpreter.send_event(event)
  end

  def current_state
    interpreter.state
  end
end