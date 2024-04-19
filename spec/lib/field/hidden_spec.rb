# typed: true

require "bleuprint/field/base"
module Bleuprint
  module Field
    class Hidden < Base
      def hidden?
        true
      end

      def type
        ""
      end

      def filterable_options
        [{ label: "Sim", value: "true" }, { label: "Não", value: "false" }]
      end
    end
  end
end
