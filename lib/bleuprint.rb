require "active_support/dependencies/autoload"
module Bleuprint
  extend ::ActiveSupport::Autoload

  autoload :CLI
  autoload :VERSION
  autoload :ThorExt
  autoload :Field
end
