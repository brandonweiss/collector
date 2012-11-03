require "collector/version"

require "collector/model"

module Collector

  def self.connection
    @@connection
  end

  def self.connection=(connection)
    @@connection = connection
  end

end
