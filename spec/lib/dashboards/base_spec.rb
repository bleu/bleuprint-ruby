# rubocop:disable RSpec/LeakyConstantDeclaration
# rubocop:disable Lint/ConstantDefinitionInBlock
# typed: false

RSpec.describe Bleuprint::Dashboards::Base do
  class TestDashboard < Bleuprint::Dashboards::Base
    ATTRIBUTE_TYPES = {
      name: Bleuprint::Field::Text,
      age: Bleuprint::Field::Number
    }.freeze

    COLLECTION_ATTRIBUTES = %i[name age].freeze

    COLLECTION_FILTERS = {
      age: ->(scope, params) { scope.where(age: params[:age]) }
    }.freeze

    SEARCH_FILTER = {
      name: :name,
      filter: lambda { |scope, params|
                scope.where("name LIKE ?", "%#{params[:name]}%")
              }
    }.freeze

    SHOW_PAGE_ATTRIBUTES = %i[name age].freeze

    def self.actions_json(*_args)
      [{ label: "Edit", url: "/edit" }]
    end

    def self.resource_class
      Struct.new(:name, :age) do
        class << self
          def columns
            [
              double(name: "name", type: :string),
              double(name: "age", type: :integer)
            ]
          end

          def where(*_args, **_kwargs)
            scope = Object.new
            scope.define_singleton_method(:where) { |*_| scope }
            scope.define_singleton_method(:order) { |*_| scope }
            scope.define_singleton_method(:page) { |*_| scope }
            scope.define_singleton_method(:per) { |*_| scope }
            scope.define_singleton_method(:total_count) { 1 }
            scope.define_singleton_method(:map) { [] }
            scope
          end

          def human_attribute_name(attr)
            attr.to_s.humanize
          end
        end
      end
    end
  end

  describe "Functionality of TestDashboard" do
    let(:resource) { double(name: "John Doe", age: 30) }

    describe ".call!" do
      it "returns columns, filters, and search configuration" do
        result = TestDashboard.call!
        expect(result).to include(:columns, :filters, :search)
      end
    end

    describe ".actions_json" do
      it "provides action configuration" do
        expect(TestDashboard.actions_json).to eq(
          [
            {
              label: "Edit",
              url:   "/edit"
            }
          ]
        )
      end
    end

    describe ".filters" do
      it "provides filters based on the configuration" do
        expect(TestDashboard.filters.first).to include(title: "Age")
      end
    end

    describe ".search" do
      it "provides search configuration" do
        expect(TestDashboard.search).to eq({ key: :name })
      end
    end

    describe ".columns" do
      it "returns columns based on attribute types and collection attributes" do
        columns = TestDashboard.columns
        expect(
          columns.map do |c|
            c[:accessorKey]
          end
        ).to include("name", "age")
      end
    end

    describe ".show_page_attributes" do
      it "returns attributes for the show page with values from the resource" do
        attributes = TestDashboard.show_page_attributes(resource)
        expect(attributes.first).to include(value: "John Doe")
      end
    end

    describe ".apply_filters" do
      let(:scope) { TestDashboard.resource_class.where }

      it "applies filters to the scope based on collection filters" do
        allow(scope).to receive(:where).with(age: 20).and_return(scope)
        filtered_scope = TestDashboard.apply_filters(scope, age: 20)
        expect(filtered_scope).to eq(scope)
      end
    end

    describe ".apply_sorting" do
      let(:scope) { TestDashboard.resource_class.where }
      let(:sorting) { { sort_column: "name", sort_direction: "asc" } }

      it "applies sorting based on provided sorting options" do
        allow(scope).to receive(:order).with("name asc").and_return(scope)

        sorted_scope = TestDashboard.apply_sorting(scope, sorting)
        expect(sorted_scope).to eq(scope)
      end
    end

    describe ".apply_pagination" do
      let(:scope) { TestDashboard.resource_class.where }
      let(:pagination) { { per_page: 2, page: 1 } }

      it "applies pagination to the scope based on provided pagination options" do
        allow(scope).to receive(:page).with(2).and_return(scope)
        allow(scope).to receive(:per).with(2).and_return(scope)
        paginated_scope = TestDashboard.apply_pagination(scope, pagination)
        expect(paginated_scope).to eq(scope)
      end
    end

    describe ".apply_field_serialization" do
      let(:scope) { [resource] }

      it "serializes the scope based on attribute types" do
        serialized_scope = TestDashboard.apply_field_serialization(scope)
        expect(serialized_scope).to all(include("name"))
      end
    end

    describe ".apply_filters_and_sorting" do
      let(:scope) { TestDashboard.resource_class.where }
      let(:filters) { { age: 25 } }
      let(:sorting) { { sort_column: "name", sort_direction: "asc" } }
      let(:pagination) { { per_page: 1, page: 0 } }

      it "applies filters, sorting, and pagination to the scope and returns structured results" do # rubocop:disable RSpec/ExampleLength
        result = TestDashboard.apply_filters_and_sorting(
          scope,
          filters,
          sorting,
          pagination
        )
        expect(result).to include(
          scope: [],
          total: 1,
          per_page: 1,
          page: 0
        )
      end
    end
  end
end

# rubocop:enable RSpec/LeakyConstantDeclaration
# rubocop:enable Lint/ConstantDefinitionInBlock
