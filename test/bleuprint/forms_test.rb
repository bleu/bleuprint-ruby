# typed: true

require "test_helper"

class FormsTest < Minitest::Test
  def test_base_autoload
    assert Bleuprint::Forms::Base
  end
end
