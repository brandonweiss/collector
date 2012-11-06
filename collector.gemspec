# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'collector/version'

Gem::Specification.new do |gem|
  gem.name          = "collector"
  gem.version       = Collector::VERSION
  gem.authors       = ["Brandon Weiss"]
  gem.email         = ["brandon@anti-pattern.com"]
  gem.description   = %q{An implementation of the Repository Pattern for MongoDB.}
  gem.summary       = %q{An implementation of the Repository Pattern for MongoDB}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "activesupport", "~> 3.2.8"
end
