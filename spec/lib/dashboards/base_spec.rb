# typed: false
# # typed: true

# RSpec.describe Bleuprint::Dashboards::Base do
#   let(:dashboard_class) do
#     Class.new(described_class) do
#       ATTRIBUTE_TYPES = {
#         name: Bleuprint::Field::Text,
#         age: Bleuprint::Field::Number
#       }.freeze
#       COLLECTION_ATTRIBUTES = %i[name age].freeze
#       COLLECTION_FILTERS = {
#         age: ->(scope, value) { scope.where(age: value) }
#       }.freeze
#       SEARCH_FILTER = {
#         name: :name,
#         filter: ->(scope, value) { scope.where("name LIKE ?", "%#{value}%") }
#       }.freeze

#       def self.actions_json(*_args)
#         [{ label: "Edit", url: "/edit" }]
#       end

#       def self.resource_class
#         OpenStruct
#       end
#     end
#   end

#   describe ".call!" do
#     it "returns columns, filters, and search" do
#       result = dashboard_class.call!
#       expect(result).to include(:columns, :filters, :search)
#     end
#   end

#   describe ".filters" do
#     it "returns filters based on COLLECTION_FILTERS" do
#       filters = dashboard_class.filters
#       expect(filters).to eq(
#         [
#           { title: "Age", value: :age, options: [] }
#         ]
#       )
#     end
#   end

#   describe ".search" do
#     it "returns search key based on SEARCH_FILTER" do
#       search = dashboard_class.search
#       expect(search).to eq({ key: :name })
#     end
#   end

#   describe ".resource_class" do
#     it "returns the correct resource class" do
#       expect(dashboard_class.resource_class).to eq(OpenStruct)
#     end
#   end

#   describe ".columns" do
#     it "returns columns based on ATTRIBUTE_TYPES and COLLECTION_ATTRIBUTES" do
#       columns = dashboard_class.columns
#       expect(columns).to eq(
#         [
#           {
#             accessorKey: "name",
#             title: "Name",
#             type: :string,
#             hide: nil,
#             field_options: {}
#           },
#           {
#             accessorKey: "age",
#             title: "Age",
#             type: :number,
#             hide: nil,
#             field_options: {}
#           },
#           {
#             id: "actions",
#             type: "actions",
#             actions: [{ label: "Edit", url: "/edit" }]
#           }
#         ]
#       )
#     end
#   end

#   describe ".show_page_attributes" do
#     let(:resource) { OpenStruct.new(name: "John", age: 25) }

#     it "returns show page attributes based on ATTRIBUTE_TYPES" do
#       attributes = dashboard_class.show_page_attributes(resource)
#       expect(attributes).to eq(
#         [
#           {
#             accessorKey: "name",
#             title: "Name",
#             type: :string,
#             value: "John",
#             field_options: {}
#           },
#           {
#             accessorKey: "age",
#             title: "Age",
#             type: :number,
#             value: 25,
#             field_options: {}
#           }
#         ]
#       )
#     end
#   end

#   describe ".apply_filters" do
#     let(:scope) { [OpenStruct.new(age: 20), OpenStruct.new(age: 30)] }
#     let(:params) { { age: 20 } }

#     it "applies filters to the scope based on COLLECTION_FILTERS" do
#       filtered_scope = dashboard_class.apply_filters(scope, params)
#       expect(filtered_scope).to eq([OpenStruct.new(age: 20)])
#     end
#   end

#   describe ".apply_sorting" do
#     let(:scope) { [OpenStruct.new(name: "John"), OpenStruct.new(name: "Alice")] }
#     let(:sorting) { { sort_column: "name", sort_direction: "asc" } }

#     it "applies sorting to the scope based on the provided sorting options" do
#       sorted_scope = dashboard_class.apply_sorting(scope, sorting)
#       expect(sorted_scope).to eq([OpenStruct.new(name: "Alice"), OpenStruct.new(name: "John")])
#     end
#   end

#   describe ".apply_pagination" do
#     let(:scope) { [1, 2, 3, 4, 5] }
#     let(:pagination) { { per_page: 2, page: 1 } }

#     it "applies pagination to the scope based on the provided pagination options" do
#       paginated_scope = dashboard_class.apply_pagination(scope, pagination)
#       expect(paginated_scope).to eq([3, 4])
#     end
#   end

#   describe ".apply_field_serialization" do
#     let(:scope) { [OpenStruct.new(name: "John", age: 25), OpenStruct.new(name: "Alice", age: 30)] }

#     it "serializes the scope based on ATTRIBUTE_TYPES" do
#       serialized_scope = dashboard_class.apply_field_serialization(scope)
#       expect(serialized_scope).to eq(
#         [
#           { "name" => "John", "age" => 25 },
#           { "name" => "Alice", "age" => 30 }
#         ]
#       )
#     end
#   end

#   describe ".apply_filters_and_sorting" do
#     let(:scope) { [OpenStruct.new(name: "John", age: 25), OpenStruct.new(name: "Alice", age: 30)] }
#     let(:filters) { { age: 25 } }
#     let(:sorting) { { sort_column: "name", sort_direction: "asc" } }
#     let(:pagination) { { per_page: 1, page: 0 } }

#     it "applies filters, sorting, and pagination to the scope and returns the result" do
#       result = dashboard_class.apply_filters_and_sorting(scope, filters, sorting, pagination)
#       expect(result).to eq(
#         {
#           scope:    [{ "name" => "John", "age" => 25 }],
#           total:    1,
#           per_page: 1,
#           page:     0
#         }
#       )
#     end
#   end
# end
