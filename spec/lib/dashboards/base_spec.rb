# rubocop:disable RSpec/LeakyConstantDeclaration
# rubocop:disable Lint/ConstantDefinitionInBlock
# typed: false

RSpec.describe Bleuprint::Dashboards::Base do
  class TestDashboard < Bleuprint::Dashboards::Base
    ATTRIBUTE_TYPES = {
      name: Bleuprint::Field::Text,
      age: Bleuprint::Field::Number
    }.freeze

    ACTIONS = {
      action_edit: Bleuprint::Field::Action::Link.with_options(
        label: "Edit",
        value: ->(_field, resource) { "/resources/#{resource&.id || 'RESOURCE_ID'}/edit" }
      ),
      action_delete: Bleuprint::Field::Action::Form.with_options(
        label: "Delete",
        value: ->(_field, resource) { "/resources/#{resource&.id || 'RESOURCE_ID'}/delete" },
        method: :delete,
        trigger_confirmation: true
      )
    }.freeze

    COLLECTION_ATTRIBUTES = %i[name age].freeze

    COLLECTION_FILTERS = {
      age: ->(scope, params) { scope.where(age: params[:age]) }
    }.freeze

    SEARCH_FILTER = {
      name: :name,
      filter: ->(scope, params) { scope.where("name LIKE ?", "%#{params[:name]}%") }
    }.freeze

    SHOW_PAGE_ATTRIBUTES = %i[name age].freeze

    def self.resource_class
      Struct.new(:id, :name, :age) do
        def self.where(*_args, **_kwargs)
          self
        end

        def self.order(*_args)
          self
        end

        def self.page(*_args)
          self
        end

        def self.per(*_args)
          self
        end

        def self.total_count
          1
        end

        def self.map(&block)
          [new(1, "John", 30)].map(&block)
        end

        def self.human_attribute_name(attr)
          attr.to_s.humanize
        end

        def where(*_args, **_kwargs)
          self
        end
      end
    end
  end

  describe "Functionality of TestDashboard" do
    let(:resource) { TestDashboard.resource_class.new(1, "John", 30) }
    let(:pagination) { { per_page: 10, page: 1 } }
    let(:sorting) { { sort_column: "name", sort_direction: "asc" } }
    let(:filters) { { age: 25 } }
    let(:context) { Bleuprint::Dashboards::DashboardContext.new(pagination:, sorting:, filters:) }
    let(:dashboard) { TestDashboard.new(pagination, sorting, filters) }

    describe "#call!" do
      it "returns columns, filters, and search configuration" do
        result = dashboard.call!
        expect(result).to include(:columns, :filters, :search)
      end
    end

    describe "#columns" do
      it "returns columns based on attribute types and collection attributes" do
        columns = dashboard.columns
        expect(columns.map { |c| c[:accessorKey] }).to eq(%w[name age actions])
      end
    end

    describe "#filters" do
      it "provides filters based on the configuration" do
        filters = dashboard.filters
        expect(filters).to eq([{ title: "Age", value: "age", options: [] }])
      end
    end

    describe "#search" do
      it "provides search configuration" do
        expect(dashboard.search).to eq({ key: "name", placeholder: nil })
      end
    end

    describe "#actions_json" do
      it "generates action links and forms with dynamic URLs" do
        actions = dashboard.actions_json(resource:)
        expect(actions).to eq(
          [
            {
              name: "Edit",
              url_path: "/resources/1/edit",
              type: :link
            },
            {
              name: "Delete",
              url_path: "/resources/1/delete",
              type: :form,
              method: :delete,
              trigger_confirmation: true
            }
          ]
        )
      end
    end

    describe "#show_page_attributes" do
      it "returns attributes for the show page with values from the resource" do
        attributes = dashboard.show_page_attributes(resource)
        expect(attributes).to eq(
          [
            {
              accessorKey: "name",
              title: "Name",
              type: :text,
              value: "John",
              hide: false,
              field_options: {}
            },
            {
              accessorKey: "age",
              title: "Age",
              type: :number,
              value: 30,
              hide: false,
              field_options: {}
            }
          ]
        )
      end
    end

    describe ".apply_filters_and_sorting" do
      it "applies filters, sorting, pagination, and serialization to the scope and returns structured results" do
        result = TestDashboard.apply_filters_and_sorting(
          TestDashboard.resource_class,
          filters,
          sorting,
          pagination
        )

        expect(result).to match(
          {
            scope:    [
              {
                name: "John",
                age: 30,
                actions: [
                  {
                    name: "Edit",
                    url_path: "/resources/1/edit",
                    type: :link
                  },
                  {
                    name: "Delete",
                    url_path: "/resources/1/delete",
                    type: :form,
                    method: :delete,
                    trigger_confirmation: true
                  }
                ]
              }
            ],
            total:    1,
            per_page: 10,
            page:     1
          }
        )
      end
    end
  end
end

# rubocop:enable RSpec/LeakyConstantDeclaration
# rubocop:enable Lint/ConstantDefinitionInBlock
