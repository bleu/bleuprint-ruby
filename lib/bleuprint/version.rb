# typed: true

module Bleuprint
  def self.version
    Gem.loaded_specs["bleuprint"].version.to_s
  end
end
