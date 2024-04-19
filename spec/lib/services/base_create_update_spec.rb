# typed: false

RSpec.describe Bleuprint::Services::ActiveRecord::BaseCreateUpdate, type: :service do
  let(:resource) { double("Resource", save!: true) }
  let(:params) { {} }
  let(:current_user) { double("User", id: 1) }

  subject { described_class.new(resource, params, current_user) }

  describe "#call!" do
    it "updates resource with params and saves" do
      allow(resource).to receive(:assign_attributes).and_return(true)
      allow(subject).to receive(:in_transaction).and_yield # Mock `in_transaction` to yield directly

      expect(subject.call!).to include(success: true, resource:)
    end
  end
end
