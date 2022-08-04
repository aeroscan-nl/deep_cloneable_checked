# DeepCloneableChecked

Use this gem to enforce explicit mentions of all associations of model you want to `deep_clone` using the `deep_clone_checked` method.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'deep_cloneable_checked'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install deep_cloneable_checked

## Usage

Call the `deep_clone_checked` method as you would normally call the `deep_clone` method from [deep_cloneable](https://github.com/moiristo/deep_cloneable) with `:include` and add `:exclude` for any associations you do not want to clone.

```ruby
human = Animal::Human.create :name => 'Michael'
human2 = Animal::Human.create :name => 'Jack'
chicken1 = Animal::Chicken.create :name => 'Chick1'
chicken2 = Animal::Chicken.create :name => 'Chick2'
human.chickens << [chicken1, chicken2]
human2.chickens << [chicken1, chicken2]

deep_clone_human = human.deep_clone_checked(:include => :ownerships, :exclude => [:pigs, {:ownerships=>[:human, :chicken]}, :chickens])
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/aeroscan-nl/deep_cloneable_checked. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/aeroscan-nl/deep_cloneable_checked/blob/main/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DeepCloneableChecked project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/aeroscan-nl/deep_cloneable_checked/blob/main/CODE_OF_CONDUCT.md).
