# typed: false

RSpec.describe Bleuprint::Field::Color, type: :model do
  describe ".input_type" do
    it "returns :switch as the input type" do
      expect(described_class.input_type).to eq(:color_picker)
    end
  end
end
