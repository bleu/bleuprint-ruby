# typed: false

require_relative "deferred"

module Bleuprint
  module Field
    class Base
      attr_reader :attribute, :dashboard, :resource, :options

      def self.with_options(options={})
        Deferred.new(self, options)
      end

      def self.type
        name.demodulize.underscore.to_sym
      end

      def self.input_type
        type
      end

      def self.filterable?
        true
      end

      def initialize(attribute, dashboard, resource=nil, options={})
        @attribute = attribute
        @dashboard = dashboard
        @resource = resource
        @options = options
      end

      def filterable?
        self.class.filterable?
      end

      def type
        self.class.type
      end

      def input_type
        self.class.input_type
      end

      def name
        attribute.to_s
      end

      def value
        resource.send(attribute) if resource.respond_to?(attribute)
      end

      def label
        dashboard.resource_class.human_attribute_name(attribute)
      end

      def hidden?
        false
      end
    end
  end
end
