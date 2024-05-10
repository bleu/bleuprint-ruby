# typed: false

module Bleuprint
  module Services
    class Base
      def self.call(*)
        new(*).call!
      rescue StandardError => e
        Rails.logger.error(e)
        on_exception(e)
        false
      end

      def self.on_exception(e)
      end
    end
  end
end
