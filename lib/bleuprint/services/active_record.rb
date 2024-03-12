# typed: strict

module Bleuprint
  module Services
    module ActiveRecord
      extend ::ActiveSupport::Autoload

      autoload :BaseAction
      autoload :BaseCreateUpdate
      autoload :BaseDestroy
    end
  end
end
