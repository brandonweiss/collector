# Collector

[![Build Status](https://travis-ci.org/brandonweiss/collector.png)](https://travis-ci.org/brandonweiss/collector)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/brandonweiss/collector)

_Collector isn't ready for use just yet. And I don't mean it's unstable or alpha, I mean literally it doesn't do anything yet. When the basic feature set is ready I will bump the minor version (to 0.1.0)._

Collector is an implementation of the Repository Pattern for MongoDB. For those new to the Repository Pattern, it is a Facade that isolates the persistence layer from your application. If you're familiar with Rails, or more specifically ActiveRecord or most other ORMs, you'll know that the models and persistence layer are tightly coupled—literally they are the same object. That pattern is a great way to cut your teeth, but ultimately it's a terrible design. Your application does not and should not care about how its data is persisted. Collector will help with that.

## Installation

Add this line to your application's Gemfile:

    gem "collector"

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install collector

## Usage

### Configuration

Set up a connection.

```ruby
Collector.connection = Mongo::Connection.new
```

### Models

Include `Collector::Model` in your domain objects to turn them into models. Create accessors for any attributes.

```ruby
class Pickle

  include Collector::Model

  attr_accessor :brine, :started_at

end
```

Models can be instantiated with a hash of attributes.

```ruby
Pickle.new(brine: "vinegar", started_at: Time.now)
```

Models automatically create and update timestamps for `created_at` and `updated_at`.

### Repositories

Include `Collector::Repository` in your repository objects to turn them into repositories. Use the same inflection as your model's name (singular).

```ruby
class PickleRepository

  include Collector::Repository

end
```

Repositories can save models.

```ruby
pickle = Pickle.new(brine: "vinegar", started_at: Time.now)
PickleRepository.save(pickle)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
