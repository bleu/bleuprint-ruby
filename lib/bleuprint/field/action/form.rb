# typed: true

require "bleuprint/field/base"
require "bleuprint/forms/action"

module Bleuprint
  module Field
    module Action
      class Form < Base
        sig { returns(NilClass) }
        def self.input_type
          nil
        end

        def as_json
          {
            name: label,
            type: type.to_s.gsub("action_", "").to_sym,
            method: options[:method],
            trigger_confirmation: options[:trigger_confirmation],
            condition_key: options[:condition_key],
            condition_value: options[:condition_value],
            url_path: value,
            form: options[:form_fields].present? ? ::Bleuprint::Forms::Action.new(resource, dashboard, options[:form_fields]).call! : {}
          }
        end
      end
    end
  end
end
