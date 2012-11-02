require File.expand_path("../../test_helper.rb", __FILE__)

describe Collector::Model do

  before do
    Object.send(:remove_const, :TestModel) if Object.const_defined?(:TestModel)
    class TestModel
      include Collector::Model
    end
  end

  it "sets attributes during initialization if a writer exists" do
    TestModel.send(:attr_reader, :foo)
    TestModel.send(:attr_writer, :foo)
    TestModel.new(foo: "bar").foo.must_equal "bar"
  end

  it "does not set attributes during initialization if a writer does not exist" do
    TestModel.send(:attr_reader, :foo)
    TestModel.new(foo: "bar").foo.must_be_nil
  end

end
