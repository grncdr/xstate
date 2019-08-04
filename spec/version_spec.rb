require "spec_helper"

describe XState::VERSION do
  it do
    XState::VERSION.wont_be_nil
  end
end
