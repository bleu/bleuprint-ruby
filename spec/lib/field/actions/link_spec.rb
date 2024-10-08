# typed: false

RSpec.describe Bleuprint::Field::Action::Link, type: :model do
  describe ".input_type" do
    it "returns nil as the input type" do
      expect(described_class.input_type).to be_nil
    end
  end

  describe ".type" do
    it "returns :action_link as the type" do
      expect(described_class.type).to eq(:action_link)
    end
  end
end
