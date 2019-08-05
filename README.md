# XState

A Ruby port of the excellent [XState](http://xstate.js.org) JavaScript library.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'xstate'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install xstate

## Usage

```rb
toggle_machine = XState::Machine.new({
  id: 'toggle',
  initial: 'inactive',
  states: {
    inactive: { on: { TOGGLE: 'active' } },
    active: { on: { TOGGLE: 'inactive' } }
  }
})

toggle_service = toggle_machine.interpreter
toggle_service.state.value #=> 'inactive'
toggle_service.send_event('TOGGLE') #=> 'active'
toggle_service.send_event('TOGGLE') #=> 'inactive'
```

## Why?

I find statecharts to be an elegant tool for modelling complicated application
behaviour, and XState in particular a very nice implementation. Among other
things, the [interactive visualizer](https://xstate.js.org/viz) is extremely
useful when discussing "what should happen?" with a team.

As such, the overall goal for this repo is to have compatibility with XState
such that a machine definition can be created in the visualizer and copy-pasted
into a Ruby file with no changes.

### Plan

The following features are implemented:

- [x] Machines
- [x] States
- [x] State Nodes
- [x] Events
- [x] Transitions
- [x] Hierarchical State Nodes
- [x] Parallel State Nodes
- [x] Final States

The following features are partly implemented/untested:

- [ ] Context
- [ ] Guards
- [ ] History
- [ ] Actions
- [ ] Identifying State Nodes

These features might be implemented, but I don't know yet if they have enough
value for Ruby applications to build them into the library:

- [ ] Action creators
  - [ ] Send action
  - [ ] Raise action
  - [ ] Log action
- [ ] Activities
- [ ] Services
- [ ] Actors
- [ ] Delayed Events and Transitions
- [ ] Interpreting Machines

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/grncdr/xstate. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Xstate project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/grncdr/xstate/blob/master/CODE_OF_CONDUCT.md).
