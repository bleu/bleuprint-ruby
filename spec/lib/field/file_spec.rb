# typed: false

RSpec.describe Bleuprint::Field::File, type: :model do
  describe "#allow_download?" do
    let(:dashboard) { double("Dashboard") }

    it "returns true" do
      field = described_class.new(:document, dashboard)
      expect(field.allow_download?).to be true
    end
  end

  describe "#value" do
    let(:resource) { double("Resource", document: mock_attachment) }
    let(:mock_attachment) { double("Attachment", attached?: true, filename: double(to_s: "filename.txt")) }
    let(:dashboard) { double("Dashboard") }

    before do
      allow(resource).to receive(:document_url).and_return("http://example.com/document")
    end

    it "returns a hash with url and filename if attached" do
      field = described_class.new(:document, dashboard, resource)
      expect(field.value).to eq({ url: "http://example.com/document", filename: "filename.txt" })
    end
  end
end
