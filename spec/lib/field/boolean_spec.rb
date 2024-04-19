# typed: false

RSpec.describe Bleuprint::Field::Boolean, type: :model do
  describe ".input_type" do
    it "returns :switch as the input type" do
      expect(described_class.input_type).to eq(:switch)
    end
  end

  describe "#filterable_options" do
    subject { described_class.new(:active, dashboard) }

    let(:dashboard) { double("Dashboard") }

    it "returns filterable options for true and false" do
      expect(subject.filterable_options).to include({ label: "Sim", value: "true" }, { label: "Não", value: "false" })
    end
  end
end
