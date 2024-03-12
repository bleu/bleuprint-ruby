# typed: true

require "active_record"
module Bleuprint
  module Forms
    class ValidatorsToJson
      def initialize(model)
        @model = model
      end

      def translate
        return unless @model.respond_to?(:validators)

        rules = {}

        @model.validators.each do |validator|
          field = validator.attributes.first
          rules[field.to_s] = rules[field.to_s] || {}
          rules[field.to_s][:name] = field.to_s

          case validator
          when ActiveRecord::Validations::PresenceValidator
            rules[field.to_s][:required] = true if validator.options.blank?
          when ActiveRecord::Validations::NumericalityValidator
            rules[field.to_s][:mode] = "number"
            rules[field.to_s][:length] = {
              minimum: validator.options[:greater_than_or_equal_to] || 0,
              maximum: validator.options[:less_than_or_equal_to] || 999_999
            }
          else
            next
          end
        end

        rules.symbolize_keys!
      end
    end
  end
end
