require "collector/version"

require "collector/model"
require "collector/repository"

module Collector

  def self.connection
    @@connection
  end

  def self.connection=(connection)
    @@connection = connection
  end

end
