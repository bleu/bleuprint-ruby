# typed: strict

require "active_support/dependencies/autoload"
require "memery"
require "sorbet-runtime"

class Object
  extend T::Sig
  extend T::Helpers
end

module Bleuprint
  include Memery

  extend ::ActiveSupport::Autoload

  autoload :Field
  autoload :Forms
  autoload :Services
  autoload :Dashboards
end
