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

    end

  end
end
