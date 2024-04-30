# typed: true

require "active_support/core_ext/module/delegation"

module Bleuprint
  module Field
    # The Deferred class is used to manage the deferred instantiation of a class and
    # manage its configuration until it is necessary to create an instance. This is particularly
    # useful in scenarios where setup of an instance is complex or depends on runtime conditions.
    #
    # @example Deferring creation of a field
    #   deferred = Bleuprint::Field::Deferred.new(SomeFieldClass, { some_option: 'value' })
    #   # Later on...
    #   instance = deferred.new(additional_option: 'another_value')
    #
    class Deferred
      # Initializes a new Deferred instance with a given class and a hash of options.
      #
      # @param deferred_class [Class] The class to be deferred for later instantiation.
      # @param options [Hash] Initial set of options for configuration of the class instance.
      def initialize(deferred_class, options={})
        @deferred_class = deferred_class
        @options = options
      end

      attr_reader :deferred_class, :options

      # Creates a new instance of the deferred class, merging any passed options with the stored options.
      #
      # @param args [Array] Arguments that will be passed to the new instance of the class.
      # @return [Object] An instance of the deferred_class.
      def new(*args)
        new_options = args.last.respond_to?(:merge) ? args.pop : {}
        deferred_class.new(*args, options.merge(new_options))
      end

      # Checks equality of two Deferred objects based on their class and options.
      #
      # @param other [Deferred] Another Deferred object to compare.
      # @return [Boolean] True if both objects defer the same class and have the same options.
      def ==(other)
        other.respond_to?(:deferred_class) &&
          deferred_class == other.deferred_class &&
          options == other.options
      end

      # Checks if the deferred class is associative.
      #
      # @return [Boolean] True if the deferred class implements and returns true for `associative?`.
      def associative?
        deferred_class.associative?
      end

      # Checks if the deferred class should eager load its associations.
      #
      # @return [Boolean] True if the deferred class implements and returns true for `eager_load?`.
      def eager_load?
        deferred_class.eager_load?
      end

      # Determines if the deferred class or the given options specify that the class is searchable.
      #
      # @return [Boolean] True if the class is searchable.
      def searchable?
        options.fetch(:searchable, deferred_class.searchable?)
      end

      # Retrieves the fields that are searchable from the options.
      #
      # @return [Array] List of fields that are searchable.
      def searchable_fields
        options.fetch(:searchable_fields)
      end

      # Retrieves the permitted attribute for the class, considering any options like `foreign_key`.
      #
      # @param attr [Symbol] The attribute to check permission for.
      # @param opts [Hash] Additional options that might modify the permission checking.
      # @return [Object] The permitted attribute value or details based on deferred class logic.
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
