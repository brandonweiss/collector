require File.expand_path("../test_helper.rb", __FILE__)

describe Collector do

  it "has a connection" do
    connection = stub()
    Collector.connection = connection
    Collector.connection.must_equal connection
  end

end
