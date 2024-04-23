# typed: strict

require "active_support/dependencies/autoload"
require "memery"
module Bleuprint
  include Memery

  extend ::ActiveSupport::Autoload

  autoload :VERSION

  autoload :Field
  autoload :Forms
  autoload :Services
  autoload :Dashboards
end
