# typed: true

require "bleuprint/field/base"
module Bleuprint
  module Field
    class Number < Base
      def self.input_type
        :input
      end
    end
  end
end
