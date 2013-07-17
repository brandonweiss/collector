module Collector
  module Model

    def self.included(base)
      attr_accessor :id
      attr_reader :created_at, :updated_at
    end

    def initialize(attributes = {})
      attributes.each do |key, value|
        instance_variable_set("@#{key}", value) if methods.include? "#{key}".to_sym
        send("#{key}=", value)                  if methods.include? "#{key}=".to_sym
      end
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

    def ==(other_model)
      return nil if self.id.nil? || other_model.id.nil?
      self.id == other_model.id
    end

  end
end
