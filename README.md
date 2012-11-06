# Collector

[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/brandonweiss/collector)

_Collector isn't ready for use just yet. When it has a basic feature set and is stable I will bump the minor version (to 0.1.0). Until then it's still effectively pre-release._

Collector is an implementation of the Repository Pattern for MongoDB. For those new to the Repository Pattern, it is a Facade that isolates the persistence layer from your application. If you're familiar with Rails, or more specifically ActiveRecord or most other ORMs, you'll know that the models and persistence layer are tightly coupled—literally they are the same object. That pattern is a great way to cut your teeth, but ultimately it's a terrible design. Your application does not and should not care about how its data is persisted. Collector will help with that.

## Installation

Add this line to your application's Gemfile:

    gem "collector"

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install collector

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
