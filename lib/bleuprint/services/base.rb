module Bleuprint
  module Services
    class Base
      def self.call(*)
        new(*).call!
      rescue StandardError => e
        Rails.logger.error(e)
        false
      end
    end
  end
end
