module Collector
  module Model

    def initialize(attributes = {})
      attributes.each do |attribute, value|
        send("#{attribute}=", value) if methods.include? "#{attribute}=".to_sym
      end
    end

  end
end
