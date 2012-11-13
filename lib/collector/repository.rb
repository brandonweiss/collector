require "active_support/inflector"

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
        attributes = serialize(model)
        collection.insert(attributes)
      end

      def serialize(model)
        model.attributes.reject { |key, val| val.nil? }
      end

    end

  end
end
