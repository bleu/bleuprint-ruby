# typed: true

require "bleuprint/field/base"
module Bleuprint
  module Field
    class Select < Base
      def value
        return unless resource.respond_to?(attribute)

        dashboard.resource_class.enumerations[attribute.to_sym].to_a.find do |value|
          value[1] == resource.send(attribute)
        end&.first || resource.send(attribute)
      end

      def selectable_options
        values =
          if options.key?(:collection)
            options.fetch(:collection)
          elsif active_record_enum?
            active_record_enum_values
          elsif enumerate_it_enum?
            enumerate_it_enum_values
          else
            []
          end

        if values.respond_to? :call
          values = values.arity.positive? ? values.call(self) : values.call
        end

        values
      end

      def active_record_enum?
        dashboard.resource_class.defined_enums.key?(attribute.to_s)
      end

      def active_record_enum_values
        dashboard.resource_class.defined_enums[attribute.to_s].map(&:first).map do |value|
          { value:, label: value.humanize }
        end
      end

      def enumerate_it_enum?
        dashboard.resource_class.enumerations.key?(attribute.to_sym)
      end

      def enumerate_it_enum_values
        dashboard.resource_class.enumerations[attribute.to_sym].to_a.map do |value|
          { value: value[1], label: value[0] }
        end
      end
    end
  end
end
