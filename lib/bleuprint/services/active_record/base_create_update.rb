# typed: true

module Bleuprint
  module Services
    module ActiveRecord
      class BaseCreateUpdate < BaseAction
        include AfterCommitEverywhere

        attr_reader :params, :current_user, :resource

        def initialize(resource, params, current_user)
          super()
          @resource = resource
          @params = params
          @current_user = current_user
        end

        def call! # rubocop:disable Metrics/AbcSize
          super do
            if resource.respond_to?(:user_id) && current_user.present?
              resource.assign_attributes(user_id: current_user.id)
            end

            # filter out params that don't exist in the resource
            filtered_params = params.select { |k, _v| resource.respond_to?(k) }

            resource.assign_attributes(**filtered_params)

            yield resource if block_given?

            resource.save!

            resource
          end
        end
      end
    end
  end
end
