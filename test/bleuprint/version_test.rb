# typed: true

require "test_helper"

class BleuprintTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Bleuprint.version
  end
end
