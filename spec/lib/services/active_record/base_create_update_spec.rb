# typed: false

RSpec.describe Bleuprint::Services::ActiveRecord::BaseCreateUpdate, type: :service do
  let(:service) { described_class.new(resource, params, current_user) }

  let(:resource) { instance_double("Resource", save!: true) }
  let(:params) { {} }
  let(:current_user) { instance_double("User", id: 1) }

  describe "#call!" do
    it "updates resource with params and saves" do
      allow(resource).to receive_messages(assign_attributes: nil, persisted?: false, changed?: true)
      allow(service).to receive(:in_transaction).and_yield # Mock `in_transaction` to yield directly

      expect(service.call!).to include(success: true, resource:)
    end
  end
end
