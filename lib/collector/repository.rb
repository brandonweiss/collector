require "active_support/inflector"
require "active_support/core_ext/hash"

module Collector
  module Repository

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods

      def collection
         Collector.connection[collection_name]
      end

      def collection_name
        ActiveSupport::Inflector.tableize(model)
      end

      def model
        name.to_s.gsub("Repository", "").constantize
      end

      def save(model)
        model.touch
        save_without_updating_timestamps(model)
      end

      def save_without_updating_timestamps(model)
        attributes = serialize!(model)
        collection.insert(attributes)
      end

      def serialize!(model)
        attributes = serialize(model)
        attributes["_id"] = attributes.delete("id")
        attributes.reject! { |key, val| val.nil? }
        attributes
      end

      def serialize(model)
        model.attributes.with_indifferent_access
      end

      # def all
      #   collection.find_all.map do |document|
      #     deserialize!(document)
      #   end
      # end

      def deserialize!(attributes)
        attributes       = attributes.with_indifferent_access
        attributes["id"] = attributes.delete("_id")
        deserialize(attributes)
      end

      def deserialize(attributes)
        model.new(attributes)
      end

    end

  end
end
