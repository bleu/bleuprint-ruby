# typed: false
# frozen_string_literal: true

require "active_support/concern"
require "active_model"

module Bleuprint
  module Forms
    class Base < Services::Base
      include ActiveModel::Validations

      attr_reader :resource, :dashboard

      validates :resource, presence: true
      validates :dashboard, presence: true

      def initialize(resource, dashboard)
        super()
        @resource = resource
        @dashboard = dashboard
      end

      def call!
        {
          fields:,
          defaultValues: default_values
        }
      end

      private

      def default_values
        return {} unless resource

        resource.as_json.merge(default_values_to_many_associations)
      end

      def default_values_to_many_associations
        has_many_associations = dashboard::ATTRIBUTE_TYPES.select do |key, type_class|
          if type_class.respond_to?(:name)
            type_class.name == "Bleuprint::Field::HasMany"
          elsif type_class.respond_to?(:deferred_class)
            type_class.deferred_class.name == "Bleuprint::Field::HasMany"
          else
            false
          end
        end

        # Map through the selected associations and build a hash of attribute keys and their values
        has_many_defaults = has_many_associations.map do |attribute, type_class|
          instance = type_class.new(attribute, dashboard, resource)
          attribute_key = instance.attribute_key

          if resource.respond_to?(attribute_key)
            {attribute_key => resource.send(attribute_key)}
          else
            {attribute_key => nil}
          end
        end

        has_many_defaults.reduce({}, :merge) || {}
      end

      def fields
        validations = Forms::ValidatorsToJson.new(resource.class).translate
        attribute_types = get_attribute_types

        attribute_types.map do |name, type_class|
          field = build_field(name, type_class)
          field_attributes(field, validations)
        end
      end

      def get_attribute_types # rubocop:disable Naming/AccessorMethodName
        dashboard::ATTRIBUTE_TYPES.slice(*dashboard::FORM_ATTRIBUTES)
      end

      def build_field(name, type_class)
        type_class.new(name, dashboard, resource)
      end

      def field_attributes(field, _validations)
        {
          name: field.name,
          type: field.input_type,
          label: field.label,
          **field.options,
          **options_for_field(field),
          # **validation_for_field(field, validations),
          **downloadable_options_for_field(field)
        }
      end

      def options_for_field(field)
        field.respond_to?(:selectable_options) ? {options: field.selectable_options} : {}
      end

      def validation_for_field(field, validations)
        validations&.dig(field.name.to_sym) || {}
      end

      def downloadable_options_for_field(field)
        field.respond_to?(:allow_download?) ? {download: field.allow_download?} : {}
      end

      def conditional_fields(array)
        conditions = array.map do |condition|
          key = condition.keys.first
          {name: key, value: condition[key]}
        end

        yield.map do |field|
          field.merge(conditions:)
        end
      end
    end
  end
end
