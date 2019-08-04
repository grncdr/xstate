require "spec_helper"

describe 'Parallel states' do
  include MachineHelper

  self.machine = {
    id: 'file',
    type: 'parallel',
    states: {
      upload: {
        initial: 'idle',
        states: {
          idle: {
            on: {
              INIT_UPLOAD: 'pending'
            }
          },
          pending: {
            on: {
              UPLOAD_COMPLETE: 'success'
            }
          },
          success: {}
        }
      },
      download: {
        initial: 'idle',
        states: {
          idle: {
            on: {
              INIT_DOWNLOAD: 'pending'
            }
          },
          pending: {
            on: {
              DOWNLOAD_COMPLETE: 'success'
            }
          },
          success: {}
        }
      }
    }
  } 

  it 'has multiple initial states' do
    machine.initial.value.must_equal('upload' => 'idle', 'download' => 'idle')
  end

  it 'transitions states independently' do
    send_event('INIT_DOWNLOAD')
    current_state.value.must_equal('upload' => 'idle', 'download' => 'pending')
    send_event('INIT_UPLOAD')
    current_state.value.must_equal('upload' => 'pending', 'download' => 'pending')
    send_event('UPLOAD_COMPLETE')
    current_state.value.must_equal('upload' => 'success', 'download' => 'pending')
    send_event('DOWNLOAD_COMPLETE')
    current_state.value.must_equal('upload' => 'success', 'download' => 'success')
  end
end
