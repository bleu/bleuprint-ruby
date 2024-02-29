require "bleuprint/field/base"
module Bleuprint
  module Field
    class Color < Base
      def self.input_type
        :color_picker
      end
    end
  end
end
