# typed: strict

require "active_support/dependencies/autoload"

module Bleuprint
  module Forms
    extend ::ActiveSupport::Autoload

    autoload :Base
    autoload :ValidatorsToJson
  end
end
