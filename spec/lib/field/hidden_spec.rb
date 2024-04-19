# typed: false

RSpec.describe Bleuprint::Field::Hidden do
  subject { described_class.new(:hidden_field, dashboard) }

  let(:dashboard) { double("Dashboard") }

  describe "#hidden?" do
    it "returns true" do
      expect(subject.hidden?).to be true
    end
  end

  describe "#type" do
    it "returns an empty string" do
      expect(subject.type).to eq("")
    end
  end

  describe "#filterable_options" do
    it "returns the correct filterable options" do
      expect(subject.filterable_options).to eq(
        [
          { label: "Sim", value: "true" },
          { label: "Não", value: "false" }
        ]
      )
    end
  end
end
