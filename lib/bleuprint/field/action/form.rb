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
            type: action_type,
            method: options[:method],
            trigger_confirmation: options[:trigger_confirmation],
            condition_key: options[:condition_key],
            condition_value: options[:condition_value],
            url_path: value,
            form: form_fields_json,
            hide: hidden?
          }
        end

        def action_type
          type.to_s.gsub("action_", "").to_sym
        end

        def form_fields_json
          if options[:form_fields].present?
            ::Bleuprint::Forms::Action.new(resource, dashboard, options[:form_fields]).call!
          else
            {}
          end
        end
      end
    end
  end
end
