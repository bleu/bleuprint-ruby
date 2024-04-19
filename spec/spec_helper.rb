# typed: true

require "rspec/support/spec"
require "bleuprint"
require "rspec/core"
require "rspec/expectations"
require "pry"
require "rspec/sorbet"

$rspec_core_without_stderr_monkey_patch = RSpec::Core::Configuration.new

class RSpec::Core::Configuration
  def self.new(*args, &)
    super.tap do |config|
      # We detect ruby warnings via $stderr,
      # so direct our deprecations to $stdout instead.
      config.deprecation_stream = $stdout
      config.include RSpec::Matchers
    end
  end
end

RSpec::Sorbet.allow_doubles!
