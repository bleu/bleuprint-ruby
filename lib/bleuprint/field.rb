# typed: strict

require "active_support/dependencies/autoload"

module Bleuprint
  module Field
    extend ::ActiveSupport::Autoload

    autoload :Action
    autoload :Base
    autoload :Boolean
    autoload :Color
    autoload :Date
    autoload :Datetime
    autoload :File
    autoload :Hidden
    autoload :Number
    autoload :Select
    autoload :Text
    autoload :Wysiwyg
    autoload :HasMany
  end
end
