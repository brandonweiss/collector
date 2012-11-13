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

  describe "#save" do
    it "touches the model and then saves it" do
      model = mock(:touch)
      TestRepository.expects(:save_without_updating_timestamps).with(model)
      TestRepository.save(model)
    end
  end

  describe "#save_without_updating_timestamps" do
    it "serializes the model and then inserts it into the collection" do
      model = stub()
      TestRepository.expects(:serialize).with(model).returns({ foo: "bar" })

      collection = mock(insert: { foo: "bar" })
      TestRepository.stubs(:collection).returns(collection)

      TestRepository.save_without_updating_timestamps(model)
    end
  end

  describe "#serialize" do
    it "returns a models attributes without nil values" do
      model = mock(attributes: { foo: "bar", nothing: nil })
      TestRepository.serialize(model).must_equal({ foo: "bar" })
    end
  end

end
