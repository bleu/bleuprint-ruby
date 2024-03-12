# typed: false

require "test_helper"

class DashboardsBaseTest < Minitest::Test
  class TestDashboard < Bleuprint::Dashboards::Base
    ATTRIBUTE_TYPES = {
      id: Bleuprint::Field::Number,
      name: Bleuprint::Field::Text
    }.freeze

    COLLECTION_ATTRIBUTES = %i[id name].freeze

    def self.actions_json
      [{ name: "Edit", type: "link", url_path: "/edit_resource" }]
    end
  end

  def setup
    @dashboard = TestDashboard
  end

  def test_attribute_types
    assert_equal Bleuprint::Field::Number, @dashboard::ATTRIBUTE_TYPES[:id]
    assert_equal Bleuprint::Field::Text, @dashboard::ATTRIBUTE_TYPES[:name]
  end

  def test_collection_attributes
    assert_equal %i[id name], @dashboard::COLLECTION_ATTRIBUTES
  end

  def test_actions_json
    expected = [{ name: "Edit", type: "link", url_path: "/edit_resource" }]
    assert_equal expected, @dashboard.actions_json
  end
end
