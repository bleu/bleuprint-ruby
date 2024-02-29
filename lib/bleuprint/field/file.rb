require "bleuprint/field/base"
module Bleuprint
  module Field
    class File < Base
      def allow_download?
        true
      end

      def value
        return {} unless resource.send(attribute).attached?

        url = resource.respond_to?(:"#{attribute}_url") ? resource.send(:"#{attribute}_url") : resource.send(attribute)

        {
          url:,
          filename: resource.send(attribute).filename.to_s
        }
      end
    end
  end
end
