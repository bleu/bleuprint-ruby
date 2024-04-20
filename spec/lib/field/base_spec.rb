# typed: false

RSpec.describe Bleuprint::Field::Base do
  let(:field) { described_class.new(attribute, dashboard, resource, options) }
  let(:attribute) { :name }
  let(:dashboard) { double("Dashboard", resource_class:) }
  let(:resource_class) { double("ResourceClass", human_attribute_name: "Name") }
  let(:resource) { instance_double("Resource", name: "John") }
  let(:options) { {} }

  describe ".with_options" do
    it "returns a new instance of Deferred with the class and options" do
      deferred = described_class.with_options(foo: "bar")
      expect(deferred).to be_a(Bleuprint::Field::Deferred)
      expect(deferred.deferred_class).to eq(described_class)
      expect(deferred.options).to eq(foo: "bar")
    end
  end

  describe ".type" do
    it "returns the underscored and symbolized class name" do
      expect(described_class.type).to eq(:base)
    end
  end

  describe ".input_type" do
    it "returns the same value as .type" do
      expect(described_class.input_type).to eq(described_class.type)
    end
  end

  describe ".filterable?" do
    it "returns true" do
      expect(described_class.filterable?).to be true
    end
  end

  describe "#initialize" do
    it "sets the attribute, dashboard, resource, and options" do
      field = described_class.new(attribute, dashboard, resource, options)
      expect(field.attribute).to eq(attribute)
      expect(field.dashboard).to eq(dashboard)
      expect(field.resource).to eq(resource)
      expect(field.options).to eq(options)
    end
  end

  describe "#filterable?" do
    it "returns the value of .filterable?" do
      expect(field.filterable?).to eq(described_class.filterable?)
    end
  end

  describe "#type" do
    it "returns the value of .type" do
      expect(field.type).to eq(described_class.type)
    end
  end

  describe "#input_type" do
    it "returns the value of .input_type" do
      expect(field.input_type).to eq(described_class.input_type)
    end
  end

  describe "#name" do
    it "returns the attribute as a string" do
      expect(field.name).to eq("name")
    end
  end

  describe "#value" do
    context "when resource responds to the attribute" do
      it "returns the value of the attribute on the resource" do
        expect(field.value).to eq("John")
      end
    end

    context "when resource does not respond to the attribute" do
      let(:resource) { double("Resource") }

      it "returns nil" do
        expect(field.value).to be_nil
      end
    end
  end

  describe "#label" do
    context "when options[:label] is a string" do
      let(:options) { { label: "Full Name" } }

      it "returns the string value of options[:label]" do
        expect(field.label).to eq("Full Name")
      end
    end

    context "when options[:label] is a proc" do
      let(:options) { { label: ->(field, resource) { "#{resource.name}'s #{field.attribute}" } } }

      it "calls the proc with the field and resource and returns the result" do
        expect(field.label).to eq("John's name")
      end
    end

    context "when options[:label] is not provided" do
      it "returns the human attribute name from the resource class" do
        expect(field.label).to eq("Name")
      end
    end
  end

  describe "#hidden?" do
    context "when options[:hidden] is a boolean" do
      context "when options[:hidden] is true" do
        let(:options) { { hidden: true } }

        it "returns true" do
          expect(field.hidden?).to be true
        end
      end

      context "when options[:hidden] is false" do
        let(:options) { { hidden: false } }

        it "returns false" do
          expect(field.hidden?).to be false
        end
      end
    end

    context "when options[:hidden] is a proc" do
      let(:options) { { hidden: ->(_field, resource) { resource.name == "John" } } }

      context "when the proc returns true" do
        it "returns true" do
          expect(field.hidden?).to be true
        end
      end

      context "when the proc returns false" do
        let(:resource) { double("Resource", name: "Jane") }

        it "returns false" do
          expect(field.hidden?).to be false
        end
      end
    end

    context "when options[:hidden] is not provided" do
      it "returns nil" do
        expect(field.hidden?).to be false
      end
    end
  end
end
