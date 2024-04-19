# typed: false

RSpec.describe Bleuprint::Field::Select, type: :model do
  let(:dashboard) { instance_double("Dashboard", resource_class:) }
  let(:enumerations) { {} }
  let(:resource_class) { instance_double("ResourceClass", defined_enums: {}, enumerations:) }
  let(:resource) { instance_double("Resource", status: "active") }
  let(:attribute) { :status }
  let(:options) { {} }
  let(:field) { described_class.new(attribute, dashboard, resource, options) }

  describe "#value" do
    before do
      allow(resource).to receive(:respond_to?).with(attribute).and_return(true)
    end

    context "when enumerations match the resource attribute value" do
      it "returns the human-readable value" do
        allow(resource_class).to receive(:enumerations).and_return(status: [%w[Active active]])
        expect(field.value).to eq("Active")
      end
    end

    context "when there is no match in enumerations" do
      it "returns the raw attribute value" do
        allow(resource_class).to receive(:enumerations).and_return({})
        expect(field.value).to eq("active")
      end
    end

    context "when resource does not respond to the attribute" do
      before { allow(resource).to receive(:respond_to?).with(attribute).and_return(false) }
      it "returns nil" do
        expect(field.value).to be_nil
      end
    end
  end

  describe "#selectable_options" do
    context "when options include a collection" do
      let(:options) { { collection: [{ value: "active", label: "Active" }] } }
      it "returns the collection from options" do
        expect(field.selectable_options).to eq([{ value: "active", label: "Active" }])
      end
    end

    context "when using ActiveRecord enum" do
      before do
        allow(field).to receive(:active_record_enum?).and_return(true)
        allow(resource_class).to receive(:defined_enums).and_return(status: { "active" => 0 })
      end
      it "returns options from ActiveRecord enum" do
        expect(field.selectable_options).to include({ value: "active", label: "Active" })
      end
    end

    context "when using EnumerateIt enum" do
      before do
        allow(field).to receive(:enumerate_it_enum?).and_return(true)
        allow(resource_class).to receive(:enumerations).and_return(status: [%w[Active active]])
      end
      it "returns options from EnumerateIt enum" do
        expect(field.selectable_options).to include({ value: "active", label: "Active" })
      end
    end

    context "when no options are available" do
      it "returns an empty array if no matching enum types found" do
        expect(field.selectable_options).to be_empty
      end
    end
  end
end
