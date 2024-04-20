# typed: false

RSpec.describe Bleuprint::Field::Deferred, type: :model do
  let(:deferred_class) do
    class_double(
      "SomeFieldClass",
      new: true,
      associative?: true,
      eager_load?: true,
      searchable?: true,
      permitted_attribute: true,
      html_class: "some-class"
    )
  end
  let(:options) { { searchable: false, searchable_fields: %w[name email], foreign_key: "user_id" } }
  let(:deferred) { described_class.new(deferred_class, options) }

  describe "#initialize" do
    it "initializes with a deferred class and options" do
      expect(deferred.deferred_class).to eq(deferred_class)
      expect(deferred.options).to eq(options)
    end
  end

  describe "#new" do
    it "creates a new instance of the deferred class with merged options" do
      deferred.new({ merged: "options" })
      expect(deferred_class).to have_received(:new).with({ **options, merged: "options" })
    end
  end

  describe "#==" do
    it "equals another deferred with the same class and options" do
      other = described_class.new(deferred_class, options)
      expect(deferred).to eq(other)
    end

    it "does not equal another deferred with different class or options" do
      other_class = class_double("AnotherFieldClass")
      other = described_class.new(other_class, options)
      expect(deferred).not_to eq(other)
    end
  end

  describe "#associative?" do
    it "delegates to the deferred_class" do
      deferred.associative?
      expect(deferred_class).to have_received(:associative?)
    end
  end

  describe "#eager_load?" do
    it "delegates to the deferred_class" do
      deferred.eager_load?
      expect(deferred_class).to have_received(:eager_load?)
    end
  end

  describe "#searchable?" do
    it "returns the option if set" do
      expect(deferred.searchable?).to be(false)
    end

    it "delegates to the deferred_class if option is not set" do
      deferred_without_option = described_class.new(deferred_class, {})
      deferred_without_option.searchable?
      expect(deferred_class).to have_received(:searchable?)
    end
  end

  describe "#searchable_fields" do
    it "fetches searchable fields from options" do
      expect(deferred.searchable_fields).to eq(%w[name email])
    end
  end

  describe "#permitted_attribute" do
    context "when foreign_key is specified in options" do
      it "returns the foreign_key from options" do
        expect(deferred.permitted_attribute(:some_attr, {})).to eq("user_id")
      end
    end

    context "when foreign_key is not specified in options" do
      it "delegates permitted_attribute to the deferred_class" do
        deferred_without_foreign_key = described_class.new(deferred_class, {})
        deferred_without_foreign_key.permitted_attribute(:some_attr, {})
        expect(deferred_class).to have_received(:permitted_attribute).with(:some_attr, {})
      end
    end
  end

  describe "delegation" do
    it "delegates html_class to the deferred_class" do
      deferred.html_class
      expect(deferred_class).to have_received(:html_class)
    end
  end
end
