require "test_helper"

class DashboardsTest < Minitest::Test
  def test_base_autoload
    assert Bleuprint::Dashboards::Base
  end
end
