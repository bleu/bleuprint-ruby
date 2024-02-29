require "test_helper"

class ServicesTest < Minitest::Test
  def test_base_autoload
    assert Bleuprint::Services::Base
  end
end
