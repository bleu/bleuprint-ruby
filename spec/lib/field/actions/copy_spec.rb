# typed: false

# # typed: true

# module Bleuprint
#   module Field
#     module Action
#       class Copy < Base
#         sig { returns(NilClass) }
#         def self.input_type
#           nil
#         end

#         def as_json
#           {
#             name: label,
#             type: type.to_s.gsub("action_", "").to_sym,
#             condition_key:,
#             condition_value:,
#             content: {
#               key: value
#             }
#           }
#         end
#       end
#     end
#   end
# end

RSpec.describe Bleuprint::Field::Action::Copy, type: :model do
  describe ".input_type" do
    it "returns nil as the input type" do
      expect(described_class.input_type).to be_nil
    end
  end

  describe ".type" do
    it "returns :action_copy as the type" do
      expect(described_class.type).to eq(:action_copy)
    end
  end
end
