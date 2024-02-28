require "thor"

module Bleuprint
  class CLI < Thor
    extend ThorExt::Start

    map %w[-v --version] => "version"

    desc "version", "Display bleuprint version", hide: true
    def version
      say "bleuprint/#{VERSION} #{RUBY_DESCRIPTION}"
    end
  end
end
