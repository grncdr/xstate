require "spec_helper"

describe 'Stoplight example' do
  include MachineHelper

  self.machine = {
    id: 'light',
    initial: 'green',
    states: {
      green: {
        on: {
          TIMER: 'yellow'
        }
      },
      yellow: {
        on: {
          TIMER: 'red'
        }
      },
      red: {
        on: {
          TIMER: 'green'
        }
      }
    }
  }

  describe '#transition' do
    it 'returns next state' do
      state = machine.initial
      assert_equal state.value, 'green'
      state = machine.transition(state, 'TIMER')
      assert_equal state.value, 'yellow'
      state = machine.transition(state, 'TIMER')
      assert_equal state.value, 'red'
      state = machine.transition(state, 'TIMER')
      assert_equal state.value, 'green'
    end
  end

  describe '#interpreter' do
    it 'maintains a current state' do
      %w[green yellow red green].each do |expected|
        interpreter.state.value.must_equal expected
        send_event('TIMER')
      end
    end
  end
end
