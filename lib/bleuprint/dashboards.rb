# typed: strict

require "active_support/dependencies/autoload"

module Bleuprint
  module Dashboards
    extend ::ActiveSupport::Autoload

    autoload :Base
  end
end
