# typed: strict

require "active_support/dependencies/autoload"

module Bleuprint
  module Services
    extend ::ActiveSupport::Autoload

    autoload :Base
    autoload :ActiveRecord
  end
end
