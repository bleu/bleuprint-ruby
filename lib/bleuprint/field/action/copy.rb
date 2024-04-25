# typed: true

module Bleuprint
  module Field
    module Action
      class Copy < Base
        sig { returns(NilClass) }
        def self.input_type
          nil
        end

        def as_json
          {
            name: label,
            type: type.to_s.gsub("action_", "").to_sym,
            condition_key:,
            condition_value:,
            content: {
              key: value
            }
          }
        end
      end
    end
  end
end
