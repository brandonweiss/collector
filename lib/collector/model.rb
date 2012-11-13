require "active_support/core_ext/hash/keys"

module Collector
  module Model

    def self.included(base)
      attr_reader :created_at, :updated_at
    end

    def initialize(attributes = {})
      attributes.symbolize_keys!

      attributes.each do |attribute, value|
        send("#{attribute}=", value) if methods.include? "#{attribute}=".to_sym
      end

      instance_variable_set("@created_at", attributes[:created_at]) if attributes[:created_at]
      instance_variable_set("@updated_at", attributes[:updated_at]) if attributes[:updated_at]
    end

    def touch
      @created_at ||= Time.now.utc
      @updated_at   = Time.now.utc
    end

    def attributes
      instance_variables.each_with_object({}) do |instance_variable, hash|
        hash[instance_variable.to_s[1..-1]] = instance_variable_get(instance_variable)
      end
    end

  end
end
