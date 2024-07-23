# typed: false
# frozen_string_literal: true

module Bleuprint
  module Forms
    class Action < Base
      attr_reader :resource, :dashboard, :form_fields

      validates :resource, presence: true
      validates :dashboard, presence: true
      validates :form_fields, presence: true

      def initialize(resource, dashboard, form_fields)
        super(resource, dashboard)
        @resource = resource
        @dashboard = dashboard
        @form_fields = form_fields
      end

      def call!
        {
          fields:
        }
      end

      def get_attribute_types # rubocop:disable Naming/AccessorMethodName
        dashboard::ATTRIBUTE_TYPES.slice(*form_fields)
      end
    end
  end
end
