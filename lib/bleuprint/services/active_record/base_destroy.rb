module Bleuprint
  module Services
    module ActiveRecord
      class BaseDestroy < BaseAction
        attr_reader :resource

        def initialize(resource)
          super()
          @resource = resource
        end

        def call!
          super do
            yield if block_given?

            resource.destroy!
          end
        end
      end
    end
  end
end
