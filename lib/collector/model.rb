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

  end
end
