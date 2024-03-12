# typed: strict

require "active_support/dependencies/autoload"
module Bleuprint
  extend ::ActiveSupport::Autoload

  autoload :VERSION

  autoload :Field
  autoload :Forms
  autoload :Services
  autoload :Dashboards
end
