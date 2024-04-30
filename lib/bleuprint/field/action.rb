# typed: strict

require "active_support/dependencies/autoload"

module Bleuprint
  module Field
    module Action
      extend ::ActiveSupport::Autoload

      autoload :Link
      autoload :Form
      autoload :Copy
    end
  end
end
