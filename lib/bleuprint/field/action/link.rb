# typed: true

require "bleuprint/field/base"

module Bleuprint
  module Field
    module Action
      class Link < Base
        sig { returns(NilClass) }
        def self.input_type
          nil
        end

        def as_json
          {
            name: label,
            type: type.to_s.gsub("action_", "").to_sym,
            url_path: value
          }
        end
      end
    end
  end
end