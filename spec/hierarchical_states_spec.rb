require 'spec_helper'

describe 'Hierarchical states' do
  include MachineHelper

  self.machine = {
    key: 'light',
    initial: 'green',
    states: {
      green: {
        on: {
          TIMER: 'yellow',
          POWER_OUTAGE: 'red'
        }
      },
      yellow: {
        on: {
          TIMER: 'red',
          POWER_OUTAGE: 'red'
        }
      },
      red: {
        on: {
          TIMER: 'green',
          POWER_OUTAGE: 'red'
        },
        initial: 'walk',
        states: {
          walk: {
            on: {
              PED_COUNTDOWN: 'wait'
            }
          },
          wait: {
            on: {
              PED_COUNTDOWN: 'stop'
            }
          },
          stop: {}
        }
      }
    }
  }

  it 'starts in a simple state' do
    current_state.value.is_a?(String)
  end

  it 'can transition into nested states' do
    send_event('TIMER')
    send_event('TIMER')
    current_state.value.must_equal('red' => 'walk')
    send_event('PED_COUNTDOWN')
    current_state.value.must_equal('red' => 'wait')
    send_event('PED_COUNTDOWN')
    current_state.value.must_equal('red' => 'stop')
  end

  it 'can transition out of nested states' do
    send_event('TIMER')
    send_event('TIMER')
    send_event('PED_COUNTDOWN')
    current_state.value.must_equal('red' => 'wait')
    send_event('TIMER')
    current_state.value.must_equal('green')
  end
end