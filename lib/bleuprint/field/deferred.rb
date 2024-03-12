# typed: true

require "active_support/core_ext/module/delegation"

module Bleuprint
  module Field
    class Deferred
      def initialize(deferred_class, options={})
        @deferred_class = deferred_class
        @options = options
      end

      attr_reader :deferred_class, :options

      def new(*args)
        new_options = args.last.respond_to?(:merge) ? args.pop : {}
        deferred_class.new(*args, options.merge(new_options))
      end

      def ==(other)
        other.respond_to?(:deferred_class) &&
          deferred_class == other.deferred_class &&
          options == other.options
      end

      def associative?
        deferred_class.associative?
      end

      def eager_load?
        deferred_class.eager_load?
      end

      def searchable?
        options.fetch(:searchable, deferred_class.searchable?)
      end

      def searchable_fields
        options.fetch(:searchable_fields)
      end

      def permitted_attribute(attr, opts={})
        if options.key?(:foreign_key)

          options.fetch(:foreign_key)
        else
          deferred_class.permitted_attribute(attr, options.merge(opts))
        end
      end

      delegate :html_class, to: :deferred_class
    end
  end
end
