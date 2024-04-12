# typed: false
# frozen_string_literal: true

require "bleuprint/services/base"

module Bleuprint
  module Dashboards
    class Base < Bleuprint::Services::Base # rubocop:disable Metrics/ClassLength
      ATTRIBUTE_TYPES = {}.freeze
      COLLECTION_ATTRIBUTES = [].freeze

      def self.call!(*)
        { columns: columns(*), filters: filters(*), search: search(*) }
      end

      def self.actions_json
        raise NotImplementedError
      end

      def self.filters(*)
        return unless defined?(self::COLLECTION_FILTERS)

        self::COLLECTION_FILTERS.map do |field_name, _filter_proc|
          field = self::ATTRIBUTE_TYPES[field_name].new(field_name, self)
          next unless field
          next unless field.filterable?

          filter_options = {}
          filter_options[:options] = field.selectable_options if field.respond_to?(:selectable_options)
          filter_options[:options] = field.filterable_options if field.respond_to?(:filterable_options)

          {
            title: field.label,
            value: field.name
          }.merge(filter_options)
        end
      end

      def self.search(*)
        return unless defined?(self::SEARCH_FILTER)

        {
          key: self::SEARCH_FILTER[:name]
        }
      end

      def self.resource_class
        class_name = name.split("::").last
        class_name.singularize.constantize # rubocop:disable Sorbet/ConstantsFromStrings
      end

      def self.base_attribute_types
        resource_class.columns.to_h do |col|
          [col.name.to_sym, determine_column_type(col)]
        end
      end

      def self.columns(*)
        columns = self::ATTRIBUTE_TYPES.slice(*self::COLLECTION_ATTRIBUTES).filter_map do |k, v|
          field = v.new(k, self, resource_class.new)
          {
            accessorKey: field.name,
            title: field.label,
            type: field.type,
            hide: field.hidden?,
            field_options: { **field.options }
          }
        end

        columns << { id: "actions", type: "actions", actions: actions_json(*) }
      end

      def self.show_page_attributes(resource)
        self::ATTRIBUTE_TYPES.slice(*self::SHOW_PAGE_ATTRIBUTES).filter_map do |k, v|
          field = v.new(k, self, resource)
          {
            accessorKey:   field.name,
            title:         field.label,
            type:          field.type,
            value:         field.value,
            field_options: { **field.options }
          }
        end
      end

      def show_page_attributes(resource)
        self.class.show_page_attributes(resource)
      end

      COLUMN_TYPE_MAPPING = {
        string: Bleuprint::Field::Text,
        text: Bleuprint::Field::Text,
        date: Bleuprint::Field::Date,
        datetime: Bleuprint::Field::Datetime,
        boolean: Bleuprint::Field::Boolean
      }.freeze

      def self.determine_column_type(column)
        COLUMN_TYPE_MAPPING[column.type] || Bleuprint::Field::Text
      end

      def self.add_collection_filter(name, &block)
        collection_filters[name] = block
      end

      def self.apply_filters(scope, params)
        return scope if params.blank?

        self::COLLECTION_FILTERS.each do |filter_name, filter_proc|
          scope = filter_proc.call(scope, params) if params[filter_name].present?
        end

        return scope unless defined?(self::SEARCH_FILTER)

        scope = self::SEARCH_FILTER[:filter].call(scope, params) if params[self::SEARCH_FILTER[:name]].present?
        scope
      end

      def self.apply_sorting(scope, sorting)
        return scope if sorting.blank?

        sort_column = sorting.fetch(:sort_column, "created_at")
        sort_direction = sorting.fetch(:sort_direction, "desc")
        scope.order("#{sort_column} #{sort_direction}")
      end

      def self.apply_pagination(scope, pagination)
        return scope if pagination.blank?

        per_page = pagination.fetch(:per_page, 10)
        page = pagination.fetch(:page, 0).to_i + 1
        scope.page(page).per(per_page)
      end

      def self.apply_field_serialization(scope)
        scope.map do |resource|
          self::ATTRIBUTE_TYPES.filter_map do |field_name, field_type|
            field = field_type.new(field_name, self, resource)
            [field.name, field.value]
          end.to_h
        end
      end

      def self.apply_filters_and_sorting(scope, filters={}, sorting={}, pagination={})
        scope = apply_filters(scope, filters)
        scope = apply_sorting(scope, sorting)
        scope = apply_pagination(scope, pagination)
        total = scope.total_count

        {
          scope: apply_field_serialization(scope),
          total:,
          per_page: pagination.fetch(:per_page, 10),
          page: pagination.fetch(:page, 0).to_i
        }
      end
    end
  end
end
