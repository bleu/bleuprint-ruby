require "bleuprint/field/base"
module Bleuprint
  module Field
    class Boolean < Base
      def self.input_type
        :switch
      end

      def filterable_options
        [{ label: "Sim", value: "true" }, { label: "Não", value: "false" }]
      end
    end
  end
end
