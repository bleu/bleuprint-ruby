# typed: false

require "bleuprint/field/associative"

module Bleuprint
  module Field
    class HasMany < Associative
      DEFAULT_LIMIT = Float::INFINITY

      def self.input_type
        :multi_select
      end

      def value
        return unless resource.respond_to?(attribute_key)

        resource.send(attribute_key)
      end

      def name
        "#{attribute.to_s.singularize}_ids"
      end

      def self.filterable?
        false
      end

      def selectable_options(_context=nil)
        label_method = options.fetch(:label_method, :title)
        select_options = options.fetch(:selectable_options, nil)
        select_options || candidate_resources.map do |associated_resource|
          {
            label: associated_resource.send(label_method),
            value: associated_resource.id
          }
        end
      end

      def self.permitted_attribute(attr, _options={})
        # This may seem arbitrary, and improvable by using reflection.
        # Worry not: here we do exactly what Rails does. Regardless of the name
        # of the foreign key, has_many associations use the suffix `_ids`
        # for this.
        #
        # Eg: if the associated table and primary key are `countries.code`,
        # you may expect `country_codes` as attribute here, but it will
        # be `country_ids` instead.
        #
        # See https://github.com/rails/rails/blob/b30a23f53b52e59d31358f7b80385ee5c2ba3afe/activerecord/lib/active_record/associations/builder/collection_association.rb#L48
        { "#{attr.to_s.singularize}_ids": [] }
      end

      def attribute_key
        permitted_attribute.keys.first
      end

      def selected_options
        return if data.empty?

        data.map { |object| object.send(association_primary_key) }
      end

      def limit
        options.fetch(:limit, DEFAULT_LIMIT)
      end

      def paginate?
        limit.respond_to?(:positive?) ? limit.positive? : limit.present?
      end

      def permitted_attribute
        self.class.permitted_attribute(
          attribute,
          resource_class: resource.class
        )
      end

      def resources
        data
      end

      def data
        @data ||= associated_class.none
      end

      private

      def candidate_resources
        if options.key?(:includes)
          includes = options.fetch(:includes)
          associated_class.includes(*includes).all
        else
          associated_class.all
        end
      end
    end
  end
end
