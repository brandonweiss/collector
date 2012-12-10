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

      def deserialize!(attributes)
        attributes       = attributes.with_indifferent_access
        attributes["id"] = attributes.delete("_id")
        deserialize(attributes)
      end

      def deserialize(attributes)
        model.new(attributes)
      end

      def find_by(attributes = {})
        collection.find(attributes).map do |document|
          deserialize!(document)
        end
      end

      def find_first_by(attributes)
        find_by(attributes).first
      end

      def all
        find_by
      end

      def find_by_id(id)
        find_by(_id: id)
      end

      def find_first_by_id(id)
        find_first_by(_id: id)
      end

      def method_missing(method_sym, *arguments, &block)
        if method_sym.to_s =~ /^find_by_(.*)$/
          find_by($1.to_sym => arguments.first)
        elsif method_sym.to_s =~ /^find_first_by_(.*)$/
          find_first_by($1.to_sym => arguments.first)
        else
          super
        end
      end

      def respond_to?(method_sym, include_private = false)
        if method_sym.to_s =~ /^find_by_(.*)$/
          true
        elsif method_sym.to_s =~ /^find_first_by_(.*)$/
          true
        else
          super
        end
      end

    end

  end
end
