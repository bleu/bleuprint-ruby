# typed: false
# frozen_string_literal: true

module Bleuprint
  module Forms
    class Wizard < Base
      private

      def fields
        validations = ::Bleuprint::Forms::ValidatorsToJson.new(resource.class).translate

        dashboard::WIZARD_FORM_STEPS.map do |step|
          {
            label: step[:label],
            fields: dashboard::ATTRIBUTE_TYPES.slice(*step[:fields]).map do |name, type_class|
              field = build_field(name, type_class)
              field_attributes(field, validations)
            end
          }
        end
      end
    end
  end
end
