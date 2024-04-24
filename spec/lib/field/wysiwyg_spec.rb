# typed: false

RSpec.describe Bleuprint::Field::Wysiwyg, type: :model do
  describe ".input_type" do
    it "returns :wysiwyg as the input type" do
      expect(described_class.input_type).to eq(:wysiwyg)
    end
  end
end
