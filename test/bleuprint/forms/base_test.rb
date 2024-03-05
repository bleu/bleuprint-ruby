require "test_helper"
require "json"
class FormsBaseTest < Minitest::Test
  class TestResource
    attr_accessor :title, :description

    def initialize
      @title = "Sample Title"
      @description = "Sample Description"
    end

    def self.model_name
      OpenStruct.new(human: "Test Resource")
    end

    def self.human_attribute_name(attribute)
      attribute.to_s.capitalize
    end

    def as_json
      { "title" => title, "description" => description }
    end
  end

  class TestForm < Bleuprint::Forms::Base
    ATTRIBUTE_TYPES = {
      title: Bleuprint::Field::Text,
      description: Bleuprint::Field::Text
    }.freeze

    FORM_ATTRIBUTES = %i[title description].freeze

    def self.resource_class
      TestResource
    end
  end

  def setup
    @resource = TestResource.new
    @form = TestForm.new(@resource, TestForm)
  end

  def test_form_fields
    result = @form.call!
    assert_equal 2, result[:fields].length
    assert(result[:fields].any? { |f| f[:name] == "title" })
    assert(result[:fields].any? { |f| f[:name] == "description" })
  end

  def test_default_values
    result = @form.call!
    assert_equal "Sample Title", result[:defaultValues]["title"]
    assert_equal "Sample Description", result[:defaultValues]["description"]
  end
end
