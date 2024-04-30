# typed: false

RSpec.describe Bleuprint::Field::Datetime, type: :model do
  describe ".input_type" do
    it "returns :datetime as the input type" do
      expect(described_class.input_type).to eq(:datetime)
    end
  end
end
