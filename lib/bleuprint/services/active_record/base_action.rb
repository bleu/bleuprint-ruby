module Bleuprint
  module Services
    module ActiveRecord
      class BaseAction < Base
        include AfterCommitEverywhere

        def call!
          resource = nil

          in_transaction do
            resource = yield
          end

          { success: true, resource: }
        rescue ActiveRecord::RecordNotDestroyed => e
          { success: false, errors: HumanizeModelErrors.new(e.record).call! }
        end
      end
    end
  end
end
