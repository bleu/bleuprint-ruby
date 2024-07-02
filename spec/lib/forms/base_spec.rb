# typed: false

RSpec.describe Bleuprint::Forms::Base, type: :model do
  describe "#initialize" do
    it "initializes with a resource and dashboard" do
      resource = double("Resource")
      dashboard = double("Dashboard")
      form = described_class.new(resource, dashboard)

      expect(form.resource).to eq(resource)
      expect(form.dashboard).to eq(dashboard)
    end
  end

  describe "#call!" do
    let(:resource) { double("Resource", as_json: {}) }
    let(:dashboard) { double("Dashboard") }
    let(:attribute_types) { {} }
    let(:form_attributes) { [] }
    let(:form) { described_class.new(resource, dashboard) }

    before do
      allow(dashboard).to receive(:const_get).with(:ATTRIBUTE_TYPES).and_return(attribute_types)
      allow(dashboard).to receive(:const_get).with(:FORM_ATTRIBUTES).and_return(form_attributes)
      allow(form).to receive_messages(fields: [], dashboard_attribute_types: attribute_types)
    end

    it "returns fields and default values" do
      expect(form.call!).to include(:fields, :defaultValues)
    end
  end
end
