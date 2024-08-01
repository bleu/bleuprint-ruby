# typed: false

# rubocop:disable RSpec/AnyInstance
RSpec.describe Bleuprint::Field::Action::Form, type: :model do
  let(:dashboard) { double("Dashboard") }
  let(:resource) { double("Resource") }
  let(:options) do
    {
      method: "post",
      trigger_confirmation: true,
      condition_key: "status",
      condition_value: "active",
      form_fields: double("FormFields")
    }
  end
  let(:field) { described_class.new(:submit, dashboard, resource, options) }

  describe ".input_type" do
    it "returns nil as the input type" do
      expect(described_class.input_type).to be_nil
    end
  end

  describe ".type" do
    it "returns :action_form as the type" do
      expect(described_class.type).to eq(:action_form)
    end
  end

  # rubocop:disable RSpec/ExampleLength
  describe "#as_json" do
    before do
      allow(field).to receive_messages(label: "Submit", value: "/submit")
      allow_any_instance_of(Bleuprint::Forms::Action).to receive(:call!).and_return({ some: "form_fields" })
    end

    it "returns a representation of the form field" do
      expected_json = {
        name: "Submit",
        type: :form,
        method: "post",
        trigger_confirmation: true,
        condition_key: "status",
        condition_value: "active",
        url_path: "/submit",
        form: { some: "form_fields" }
      }
      expect(field.as_json).to eq(expected_json)
    end
  end
  # rubocop:enable RSpec/ExampleLength

  describe "#action_type" do
    it "returns the action type without 'action_' prefix" do
      expect(field.action_type).to eq(:form)
    end
  end

  describe "#form_fields_json" do
    context "when form_fields option is present" do
      it "returns the form fields as json" do
        allow_any_instance_of(Bleuprint::Forms::Action).to receive(:call!).and_return({ some: "form_fields" })
        expect(field.form_fields_json).to eq({ some: "form_fields" })
      end
    end

    context "when form_fields option is not present" do
      let(:options) { {} }

      it "returns an empty hash" do
        expect(field.form_fields_json).to eq({})
      end
    end
  end

  describe "#label" do
    it "returns the label of the field" do
      allow(field).to receive(:label).and_return("Submit")
      expect(field.label).to eq("Submit")
    end
  end

  describe "#value" do
    context "when value is a proc" do
      let(:options) { { value: proc { |_field, _resource| "dynamic_value" } } }

      it "evaluates the proc" do
        expect(field.value).to eq("dynamic_value")
      end
    end

    context "when resource responds to attribute" do
      let(:resource) { double("Resource", submit: "static_value") }

      it "returns the attribute value from resource" do
        expect(field.value).to eq("static_value")
      end
    end

    context "when no value or attribute is present" do
      let(:options) { {} }
      let(:resource) { double("Resource") }

      it "returns nil" do
        expect(field.value).to be_nil
      end
    end
  end
end
# rubocop:enable RSpec/AnyInstance
