# typed: false

require_relative "deferred"
require "active_support/inflector"

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
        value = (options[:value].call(self, resource) if options[:value].is_a?(Proc))

        value ||= resource.send(attribute) if resource.respond_to?(attribute)

        value
      end

      def label
        label_value = if options[:label].is_a?(String)
                        options[:label]
                      elsif options[:label].is_a?(Proc)
                        options[:label].call(self, resource)
                      end

        label_value ||= dashboard.resource_class.human_attribute_name(attribute)

        label_value
      end

      def hidden?
        if options[:hidden].is_a?(TrueClass) || options[:hidden].is_a?(FalseClass)
          options[:hidden]
        elsif options[:hidden].is_a?(Proc)
          options[:hidden].call(self, resource)
        else
          false
        end
      end
    end
  end
end
