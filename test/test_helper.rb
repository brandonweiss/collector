require "rubygems"
require "bundler"
Bundler.require(:default, :test)

$:.unshift File.expand_path("../../lib", __FILE__)
require "collector"

require "minitest/autorun"
require "mocha"
