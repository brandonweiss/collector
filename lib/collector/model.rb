module Collector
  module Model

    def self.included(base)
      attr_reader :created_at, :updated_at
    end

    def initialize(attributes = {})
      attributes.each do |attribute, value|
        send("#{attribute}=", value) if methods.include? "#{attribute}=".to_sym
      end

      created_at = attributes["created_at"] || attributes[:created_at]
      updated_at = attributes["updated_at"] || attributes[:updated_at]
      instance_variable_set("@created_at", created_at) if created_at
      instance_variable_set("@updated_at", updated_at) if updated_at
    end

    def touch
      @created_at ||= Time.now.utc
      @updated_at   = Time.now.utc
    end

  end
end
