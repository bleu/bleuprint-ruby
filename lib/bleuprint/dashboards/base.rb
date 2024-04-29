# typed: false
# frozen_string_literal: true

require "bleuprint/services/base"
require "rails"
require "active_support/core_ext"

module Bleuprint
  module Dashboards
    DashboardContext = Struct.new(:pagination, :sorting, :filters, keyword_init: true)

    class Base < Bleuprint::Services::Base
      COLUMN_TYPE_MAPPING = {
        string: Bleuprint::Field::Text,
        text: Bleuprint::Field::Text,
        date: Bleuprint::Field::Date,
        datetime: Bleuprint::Field::Datetime,
        boolean: Bleuprint::Field::Boolean
      }.freeze

      attr_reader :context

      def initialize(pagination={}, sorting={}, filters={})
        super()
        validate_inheritance
        @context = DashboardContext.new(pagination:, sorting:, filters:)
        validate_required_constants
      end

      def call!
        {
          columns:,
          filters:,
          search:
        }
      end

      def columns
        self.class::ATTRIBUTE_TYPES.slice(*self.class::COLLECTION_ATTRIBUTES).map do |field_name, field_class|
          field_class.new(field_name, self.class, resource_class.new).as_json
        end + [{ id: "actions", type: "actions", accessorKey: "actions", actions: actions_json(resource: nil) }]
      end

      def filters
        self.class::COLLECTION_FILTERS.filter_map do |field_name, filter_proc|
          field = find_field(field_name)
          next unless field&.filterable?

          {
            title: field.label,
            value: field.name,
            options: field.selectable_options(context) || filter_proc&.call(nil, {})
          }
        end
      end

      def search
        return {} unless self.class.const_defined?(:SEARCH_FILTER)

        field = find_field(self.class::SEARCH_FILTER[:name])
        {
          key: field.name,
          placeholder: field.placeholder
        }
      end

      def actions_json(resource: nil)
        return [] unless self.class.const_defined?(:ACTIONS)

        resource ||= resource_class.new

        self.class::ACTIONS.filter_map do |key, action|
          next unless action.is_a?(Bleuprint::Field::Deferred)
          unless Bleuprint::Field::Action.const_defined?(action.deferred_class.name)
            raise "Deferred class #{action.deferred_class.name} not found."
          end

          action.new(key, self.class, resource, { context: }).as_json
        end.compact
      end

      def apply_filters_and_sorting(scope)
        scope = apply_filters(scope, context.filters)
        scope = apply_sorting(scope, context.sorting)
        scope = apply_pagination(scope, context.pagination)
        total = scope.total_count

        {
          scope: apply_field_serialization(scope),
          total:,
          per_page: context.pagination.fetch(:per_page, 10),
          page: context.pagination.fetch(:page, 0).to_i
        }
      end

      def show_page_attributes(resource)
        return {} if self.class::ATTRIBUTE_TYPES.blank?

        self.class::ATTRIBUTE_TYPES.slice(*self.class::SHOW_PAGE_ATTRIBUTES).map do |field_name, field_class|
          field_class.new(field_name, self, resource).as_json
        end
      end

      def resource_class
        self.class.resource_class
      end

      def apply_field_serialization(scope)
        scope.map do |resource|
          self.class::ATTRIBUTE_TYPES.slice(*self.class::COLLECTION_ATTRIBUTES).to_h do |field_name, field_class|
            field = field_class.new(field_name, self.class, resource)
            [field.name.to_sym, field.value]
          end.merge(actions: actions_json(resource:)).with_indifferent_access
        end
      end

      private

      def validate_inheritance
        return if is_a?(Bleuprint::Dashboards::Base)

        raise "#{self.class.name} must inherit from Bleuprint::Dashboards::Base"
      end

      def validate_required_constants
        # ACTIONS is not required yet
        required_constants = %i[ATTRIBUTE_TYPES COLLECTION_ATTRIBUTES COLLECTION_FILTERS]
        missing_constants = required_constants.reject { |constant| self.class.const_defined?(constant) }
        raise "Missing required constants: #{missing_constants.join(', ')}" if missing_constants.any?
      end

      def find_field(field_name)
        self.class::ATTRIBUTE_TYPES[field_name]&.new(field_name, self.class, resource_class.new)
      end

      def apply_filters(scope, filters)
        return scope if filters.blank?

        self.class::COLLECTION_FILTERS.reduce(scope) do |current_scope, (filter_name, filter_proc)|
          filters[filter_name].present? ? filter_proc.call(current_scope, filters) : current_scope
        end
      end

      def apply_sorting(scope, sorting)
        return scope if sorting.blank?

        scope.order("#{sorting[:sort_column] || 'created_at'} #{sorting[:sort_direction] || 'desc'}")
      end

      def apply_pagination(scope, pagination)
        return scope if pagination.blank?

        scope.page(pagination[:page].to_i + 1).per(pagination[:per_page] || 10)
      end

      class << self
        def call!
          new.call!
        end

        def apply_filters_and_sorting(scope, filters, sorting, pagination)
          new(pagination, sorting, filters).apply_filters_and_sorting(
            scope
          )
        end

        def apply_field_serialization(scope)
          new.apply_field_serialization(scope)
        end

        def resource_class
          name.split("::").last.singularize.delete_suffix("Dashboard").constantize # rubocop:disable Sorbet/ConstantsFromStrings
        end
      end
    end
  end
end
