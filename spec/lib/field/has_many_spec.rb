# typed: false

RSpec.describe Bleuprint::Field::HasMany do
  let(:field) { described_class.new(attribute, dashboard, resource, options) }
  let(:attribute) { :comments }
  let(:dashboard) { double("Dashboard", resource_class:) }
  let(:resource_class) { double("ResourceClass") }
  let(:resource) do
    instance_double("Resource", comment_ids: associated_resources_ids, comments: associated_resources, class: resource_class)
  end
  let(:associated_resources_ids) { [1, 2] }
  let(:associated_resources) do
    [double("AssociatedResource", id: 1, title: "Comment 1"), double("AssociatedResource", id: 2, title: "Comment 2")]
  end
  let(:options) { {} }

  let(:reflection) do
    double("Reflection", foreign_key: :comment_ids, association_primary_key: :id, klass: associated_class)
  end

  let(:associated_class) do
    double("AssociatedClass", name: "AssociatedResource", all: associated_resources, none: [])
  end

  before do
    allow(resource_class).to receive(:reflect_on_association).with(attribute).and_return(reflection)
    allow(associated_class).to receive(:includes).and_return(associated_class)
  end

  describe "#selectable_options" do
    context "when selectable_options are provided in options" do
      let(:options) { { selectable_options: [{ label: "Option 1", value: 1 }, { label: "Option 2", value: 2 }] } }

      it "returns the provided selectable_options" do
        expect(field.selectable_options).to eq(options[:selectable_options])
      end
    end

    context "when selectable_options are not provided in options" do
      it "returns the associated resources as selectable options" do
        expect(field.selectable_options).to eq(
          [
            { label: "Comment 1", value: 1 },
            { label: "Comment 2", value: 2 }
          ]
        )
      end
    end
  end

  describe ".input_type" do
    it "returns :multi_select" do
      expect(described_class.input_type).to eq(:multi_select)
    end
  end

  describe "#value" do
    context "when the resource responds to the attribute_key" do
      it "returns the associated resources" do
        expect(field.value).to eq(associated_resources_ids)
      end
    end

    context "when the resource does not respond to the attribute_key" do
      let(:resource) { double("Resource") }

      it "returns nil" do
        expect(field.value).to be_nil
      end
    end
  end

  describe "#name" do
    it "returns the singularized attribute name with '_ids' suffix" do
      expect(field.name).to eq("comment_ids")
    end
  end

  describe ".filterable?" do
    it "returns false" do
      expect(described_class.filterable?).to be false
    end
  end

  describe ".permitted_attribute" do
    it "returns the attribute with '_ids' as an array" do
      expect(described_class.permitted_attribute(:comment)).to eq({ comment_ids: [] })
    end
  end

  describe "#attribute_key" do
    it "returns the first key of permitted_attribute" do
      expect(field.attribute_key).to eq(:comment_ids)
    end
  end

  describe "#selected_options" do
    context "when data is present" do
      let(:data) { associated_resources }

      before do
        allow(field).to receive(:data).and_return(data)
      end

      it "returns the IDs of the associated resources" do
        expect(field.selected_options).to eq([1, 2])
      end
    end

    context "when data is empty" do
      before do
        allow(field).to receive(:data).and_return([])
      end

      it "returns nil" do
        expect(field.selected_options).to be_nil
      end
    end
  end

  describe "#limit" do
    context "when limit is provided in options" do
      let(:options) { { limit: 10 } }

      it "returns the provided limit" do
        expect(field.limit).to eq(10)
      end
    end

    context "when limit is not provided in options" do
      it "returns the default limit" do
        expect(field.limit).to eq(described_class::DEFAULT_LIMIT)
      end
    end
  end

  describe "#paginate?" do
    context "when limit is positive" do
      let(:options) { { limit: 10 } }

      it "returns true" do
        expect(field.paginate?).to be true
      end
    end

    context "when limit is not positive" do
      let(:options) { { limit: 0 } }

      it "returns false" do
        expect(field.paginate?).to be false
      end
    end
  end

  describe "#data" do
    it "returns an empty collection of the associated class by default" do
      allow(field).to receive(:associated_class).and_return(double("AssociatedClass", none: []))
      expect(field.data).to eq([])
    end
  end

  describe "#candidate_resources" do
    context "when includes option is provided" do
      let(:options) { { includes: [:associated] } }

      it "returns the associated class with includes" do
        expect(field.send(:candidate_resources)).to eq(associated_resources)
      end
    end

    context "when includes option is not provided" do
      it "returns all associated class resources" do
        expect(field.send(:candidate_resources)).to eq(associated_resources)
      end
    end
  end
end
