require File.expand_path("../../test_helper.rb", __FILE__)

describe Collector::Repository do

  before do
    Object.send(:remove_const, :TestRepository) if Object.const_defined?(:TestRepository)
    class TestRepository
      include Collector::Repository
    end
  end

  it "has a model derived from its class name" do
    TestRepository.model.name.must_equal "Test"
  end

  it "has a collection_name derived from its model" do
    TestRepository.collection_name.must_equal "tests"
  end

  describe "#collection" do
    describe "when a connection is set" do
      it "returns the mongo collection" do
        collection = mock()
        connection = mock { stubs(:[]).with("tests").returns(collection) }
        Collector.stubs(:connection).returns(connection)

        TestRepository.collection.must_equal collection
      end
    end
  end

end
