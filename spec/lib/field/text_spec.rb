# typed: false

RSpec.describe Bleuprint::Field::Text, type: :model do
  describe ".input_type" do
    it "returns :input as the input type" do
      expect(described_class.input_type).to eq(:input)
    end
  end
end
