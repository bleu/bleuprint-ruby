# test/bleuprint_test.rb
require "minitest/autorun"

class BleuprintTest < Minitest::Test
  def test_autoloads_modules # rubocop:disable Minitest/MultipleAssertions
    assert Bleuprint::CLI
    assert Bleuprint::VERSION
    assert Bleuprint::ThorExt
    assert Bleuprint::Field
    assert Bleuprint::Forms
    assert Bleuprint::Services
    assert Bleuprint::Dashboards
  end
end
