# Collector

[![Build Status](https://travis-ci.org/brandonweiss/collector.png)](https://travis-ci.org/brandonweiss/collector)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/brandonweiss/collector)

Collector is an implementation of the Repository Pattern for MongoDB. For those new to the Repository Pattern, it is a Facade that isolates the persistence layer from your application. If you're familiar with Rails, or more specifically ActiveRecord or most other ORMs, you'll know that the models and persistence layer are tightly coupled—literally they are the same object. That pattern is a great way to cut your teeth, but ultimately it's a terrible design. Your application does not and should not care about how its data is persisted. Collector will help with that.

_Collector is currently under initial development, and I mean that in the context of [semantic versioning](http://semver.org), which I follow. Initial development is anything with a major version of zero (0.x.x), which means anything may change at any time; there is no public API. I'll do my best not to wildly change anything, but if you upgrade, run your application tests to see if anything breaks. If you don't have application tests then you have failed. Go home and re-think your life choices that have brought you to this point._

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

Include `Collector::Repository` in an object to turn it into a repository for a model of the same name. Use the same inflection as your model's name (singular).

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

Repositories can find all models, find by id, find dynamically by any attribute, and then find first by id or any other attribute.

```ruby
PickleRepository.all
PickleRepository.find_by_id(BSON::ObjectId("50af1f3fb392d4aa0d000001"))
PickleRepository.find_by_color("green")
PickleRepository.find_by_taste("delicious")
PickleRepository.find_first_by_id(BSON::ObjectId("50af1f3fb392d4aa0d000001"))
PickleRepository.find_first_by_color("green")
PickleRepository.find_first_by_taste("delicious")
```

### Requirements

Collector will only work with 1.9.x and above. Specifically it's tested with 1.9.2 and 1.9.3.

## FAQ

### What databases does it support?

Currently only MongoDB. I'd like to add an in-memory store, and if possible, a file store and Redis store.

### Why is this better than an ORM?

If you don't already know why you need or want the Repository Pattern, then don't use it yet. It took me far longer than it should have to realize the benefits, despite having them explained to me many times. I just never really understood them until I'd actually experienced the pain this pattern solves myself. Once you do, come back and try it out.

### This looks awfully similar to [curator](http://github.com/braintreee/curator). What's the difference?

I rolled my own application-specific version of the Repository Pattern for each project I worked on before I realized I was using it often enough to merit extracting it into a gem. Right about that time Braintree announced curator, and since both their implentation and mine were very similar—except theirs was further along and had more features—I decided to use theirs instead. But after using it for a few months and then reading through the code to try and contribute back to it, I decided to go back to my own implementation and extract it into a gem after all.

The biggest diference between curator and collector is that although curator is open source, I feel like a lot of the decisions made were and are in the interest of Braintree and the people that work there, rather than what is best for the project and the people who use it. The specific, functional differens are:

<table>
  <thead>
    <tr>
      <td>Project</td>
      <td>Stores</td>
      <td>Test suite</td>
      <td>Ruby version(s)</td>
    </tr>
  </thead>

  <tbody>
    <tr>
      <td>collector</td>
      <td>MongoDB</td>
      <td>MiniTest</td>
      <td>1.9.x</td>
    </tr>

    <tr>
      <td>curator</td>
      <td>MongoDB, Riak, In-memory</td>
      <td>RSpec</td>
      <td>1.9.x, 1.8.7</td>
    </tr>
  </tbody>
</table>

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
