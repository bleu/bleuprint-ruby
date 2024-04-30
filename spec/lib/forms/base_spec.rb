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
    it "returns fields and default values" do
      resource = double("Resource", as_json: {})
      dashboard = double("Dashboard")
      form = described_class.new(resource, dashboard)

      allow(form).to receive(:fields).and_return([])

      expect(form.call!).to include(:fields, :defaultValues)
    end
  end
end
