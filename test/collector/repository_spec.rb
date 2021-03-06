require File.expand_path("../../test_helper.rb", __FILE__)

describe Collector::Repository do

  before do
    Object.send(:remove_const, :TestModel) if Object.const_defined?(:TestModel)
    class TestModel
      include Collector::Model
    end

    Object.send(:remove_const, :TestRepository) if Object.const_defined?(:TestRepository)
    class TestModelRepository
      include Collector::Repository
    end
  end

  it "has a model derived from its class name" do
    TestModelRepository.model.name.must_equal "TestModel"
  end

  it "has a collection_name derived from its model" do
    TestModelRepository.collection_name.must_equal "test_models"
  end

  describe "collection" do
    describe "when a connection is set" do
      it "returns the mongo collection" do
        collection = mock()
        connection = mock { stubs(:[]).with("test_models").returns(collection) }
        Collector.stubs(:connection).returns(connection)

        TestModelRepository.collection.must_equal collection
      end
    end
  end

  describe "save" do
    it "touches the model and then saves it" do
      model = mock(:touch)
      TestModelRepository.expects(:save_without_updating_timestamps).with(model)
      TestModelRepository.save(model)
    end
  end

  describe "save_without_updating_timestamps" do
    it "serializes the model and then saves it into the collection" do
      model = stub()
      TestModelRepository.expects(:serialize!).with(model).returns({ foo: "bar" })

      collection = mock(save: { foo: "bar" })
      TestModelRepository.stubs(:collection).returns(collection)

      TestModelRepository.save_without_updating_timestamps(model)
    end

    it "returns the model with its id set" do
      model = TestModel.new(id: "123abc")
      TestModelRepository.expects(:serialize!).with(model).returns({ foo: "bar" })

      object_id  = stub(to_s: "123abc")
      collection = mock { expects(:save).with({ foo: "bar" }).returns(object_id) }
      TestModelRepository.stubs(:collection).returns(collection)

      updated_model = TestModelRepository.save_without_updating_timestamps(model)
      updated_model.must_equal model
    end
  end

  describe "delete" do
    it "deletes the model from the collection" do
      model = stub(id: "50c58f4ab392d4381a000001")

      collection = mock { expects(:remove).with(_id: BSON::ObjectId("50c58f4ab392d4381a000001")) }
      TestModelRepository.stubs(:collection).returns(collection)

      TestModelRepository.delete(model)
    end
  end

  describe "serialize!" do
    it "normalize id to _id and normalize to an ObjectId" do
      model = mock(attributes: { id: "50c58f4ab392d4381a000001", foo: "bar" })
      TestModelRepository.serialize!(model).must_equal({ "_id" => BSON::ObjectId("50c58f4ab392d4381a000001"), "foo" => "bar" })
    end

    it "normalize id to _id and leave it as a string if it is not an ObjectId" do
      model = mock(attributes: { id: "some-string", foo: "bar" })
      TestModelRepository.serialize!(model).must_equal({ "_id" => "some-string", "foo" => "bar" })
    end

    it "returns a model's attributes without nil values" do
      model = mock(attributes: { foo: "bar", nothing: nil })
      TestModelRepository.serialize!(model).must_equal({ "foo" => "bar" })
    end
  end

  describe "serialize" do
    it "returns a model's attributes" do
      model = mock(attributes: { foo: "bar" })
      TestModelRepository.serialize(model).must_equal({ "foo" => "bar" })
    end
  end

  describe "deserialize!" do
    it "normalizes _id to id and converts to a string id" do
      TestModelRepository.expects(:deserialize).with("id" => "50c58f4ab392d4381a000001", "name" => "Brandon")
      TestModelRepository.deserialize!(_id: BSON::ObjectId("50c58f4ab392d4381a000001"), name: "Brandon")
    end
  end

  describe "deserialize" do
    it "instantiates a new model from a hash of attributes" do
      attributes = { first_name: "Brandon", last_name: "Weiss" }
      TestModelRepository.model.expects(:new).with(attributes)
      TestModelRepository.deserialize(attributes)
    end
  end

  describe "find_by" do
    it "finds documents by a hash of attributes" do
      document_1 = stub
      document_2 = stub
      documents  = [document_1, document_2]
      TestModelRepository.expects(:deserialize!).with(document_1)
      TestModelRepository.expects(:deserialize!).with(document_2)
      collection = mock { expects(:find).with(attribute: "value").returns(documents) }
      TestModelRepository.expects(:collection).returns(collection)
      TestModelRepository.find_by(attribute: "value")
    end

    it "finds all documents if no attributes are given" do
      document_1 = stub
      document_2 = stub
      documents  = [document_1, document_2]
      TestModelRepository.expects(:deserialize!).with(document_1)
      TestModelRepository.expects(:deserialize!).with(document_2)
      collection = mock { expects(:find).with({}).returns(documents) }
      TestModelRepository.expects(:collection).returns(collection)
      TestModelRepository.find_by
    end

    it "normalizes the id into a BSON::ObjectId if it's valid ObjectId" do
      collection = mock { expects(:find).with(_id: BSON::ObjectId("50c58f4ab392d4381a000001")).returns([]) }
      TestModelRepository.expects(:collection).returns(collection)
      TestModelRepository.find_by(_id: "50c58f4ab392d4381a000001")
    end

    it "does nothing with the id if it's not a valid BSON::ObjectId" do
      collection = mock { expects(:find).with(_id: "lols").returns([]) }
      TestModelRepository.expects(:collection).returns(collection)
      TestModelRepository.find_by(_id: "lols")
    end
  end

  describe "find_first_by" do
    it "finds the first document by a hash of attributes" do
      TestModelRepository.expects(:find_by).with(attribute: "value").returns(mock(:first))
      TestModelRepository.find_first_by(attribute: "value")
    end
  end

  describe "all" do
    it "finds by attributes without any attributes" do
      TestModelRepository.expects(:find_by).with()
      TestModelRepository.all
    end
  end

  describe "find_by_id" do
    it "finds by id" do
      TestModelRepository.expects(:find_by).with(_id: "bson-id")
      TestModelRepository.find_by_id("bson-id")
    end
  end

  describe "find_first_by_id" do
    it "finds first by id" do
      TestModelRepository.expects(:find_first_by).with(_id: "bson-id")
      TestModelRepository.find_first_by_id("bson-id")
    end
  end

  describe "dynamic finders" do
    it "dynamically matches find_by_ finders" do
      TestModelRepository.expects(:find_by).with(email: "foobar@fibroblast.com")
      TestModelRepository.find_by_email("foobar@fibroblast.com")
    end

    it "dynamically matches find_first_by_ finders" do
      TestModelRepository.expects(:find_first_by).with(email: "foobar@fibroblast.com")
      TestModelRepository.find_first_by_email("foobar@fibroblast.com")
    end

    it "responds to dynamically matched find_by_ finders" do
      TestModelRepository.respond_to?(:find_by_email).must_equal true
    end

    it "responds to dynamically matched find_first_by_ finders" do
      TestModelRepository.respond_to?(:find_first_by_email).must_equal true
    end
  end

end
