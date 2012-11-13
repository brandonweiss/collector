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

  it "has a created_at and updated_at timestamp" do
    now        = Time.now
    test_model = TestModel.new
    test_model.instance_variable_set("@created_at", now)
    test_model.created_at.must_equal now
  end

  it "sets timestamps via instance variables during initialization" do
    now        = Time.now
    test_model = TestModel.new(created_at: now, updated_at: now)
    test_model.created_at.must_equal now
    test_model.updated_at.must_equal now
  end

  describe "#touch" do
    it "sets the timestamps" do
      Timecop.freeze

      test_model = TestModel.new
      test_model.touch
      test_model.created_at.must_equal Time.now.utc
      test_model.updated_at.must_equal Time.now.utc
      test_model.created_at.utc?.must_equal true
      test_model.updated_at.utc?.must_equal true
    end

    it "does not set the created_at if it's already been set" do
      Timecop.freeze

      now        = Time.now
      test_model = TestModel.new
      test_model.touch
      test_model.created_at.must_equal now.utc

      Timecop.travel(Time.now + 1000)
      test_model.touch

      test_model.created_at.must_equal now.utc
    end
  end

  describe "#attributes" do
    it "returns a hash of instance variable names and their values" do
      TestModel.send(:attr_writer, :name)
      test_model = TestModel.new(name: "Foobar", created_at: 123)
      test_model.attributes.must_equal({ "name" => "Foobar", "created_at" => 123 })
    end
  end

end
