# Bleuprint

Bleuprint is a powerful Ruby gem that simplifies the creation of dashboards and forms within Rails applications. It provides a structured and modular approach to managing fields, filters, and actions across different resources, making it easy to build robust and customizable admin interfaces.

## Features

- Modular Field Definitions: Define attributes and fields for various models, ensuring customization and control over how data is presented and manipulated in your application.
- Dashboard Functionality: Simplifies the process of creating dashboard views with sorting, pagination, and filtering capabilities.
- Form Handling: Streamlines form processes with automatic validations, input handling, and structured data output.
- Custom Field Types: Supports numerous field types like text, number, boolean, date, datetime, file, select, and hidden. These types provide customized rendering and interaction mechanisms.
- Deferred Instantiation: Uses a deferred instantiation pattern for fields, allowing complex setups and runtime condition evaluations.
- Service Objects: Provides base classes for implementing common service patterns, such as creating, updating, and destroying resources using ActiveRecord.

Bleuprint
Bleuprint is a powerful Ruby gem that simplifies the creation of dashboards and forms within Rails applications. It provides a structured and modular approach to managing fields, filters, and actions across different resources, making it easy to build robust and customizable admin interfaces.

Features
Modular Field Definitions: Define attributes and fields for various models, ensuring customization and control over how data is presented and manipulated in your application.
Dashboard Functionality: Simplifies the process of creating dashboard views with sorting, pagination, and filtering capabilities.
Form Handling: Streamlines form processes with automatic validations, input handling, and structured data output.
Custom Field Types: Supports numerous field types like text, number, boolean, date, datetime, file, select, and hidden. These types provide customized rendering and interaction mechanisms.
Deferred Instantiation: Uses a deferred instantiation pattern for fields, allowing complex setups and runtime condition evaluations.
Service Objects: Provides base classes for implementing common service patterns, such as creating, updating, and destroying resources using ActiveRecord.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bleuprint'
```

And then execute:

```bash
bundle install
```

## Usage

### Dashboards

Dashboards are a central component of Bleuprint, where you can configure collections of data represented through fields. Here's an example of defining a simple dashboard:

```ruby
# app/dashboards/user_dashboard.rb
class UserDashboard < Bleuprint::Dashboards::Base
  ATTRIBUTE_TYPES = {
    name: Bleuprint::Field::Text,
    email: Bleuprint::Field::Text,
    age: Bleuprint::Field::Number,
    registered_on: Bleuprint::Field::Date
  }.freeze

  COLLECTION_ATTRIBUTES = %i[name email age].freeze

  COLLECTION_FILTERS = {
    age: ->(scope, params) { scope.where(age: params[:age]) }
  }.freeze

  SEARCH_FILTER = {
    name: :name,
    filter: ->(scope, params) { scope.where("name ILIKE ?", "%#{params[:name]}%") }
  }.freeze

  SHOW_PAGE_ATTRIBUTES = %i[name email age registered_on].freeze

  def self.actions_json(*_args)
    [{ label: "Edit", url: "/edit" }]
  end
end
```

For more details on configuring dashboards, refer to the lib/bleuprint/dashboards/base.rb file.

### Forms

Forms in Bleuprint are used to handle data entry scenarios. Here's an example of defining a form:

```ruby
# app/forms/user_form.rb
class UserForm < Bleuprint::Forms::Base
  private

  def fields
    [
      {
        name: :name,
        type: :text,
        label: "Name",
        required: true
      },
      {
        name: :email,
        type: :text,
        label: "Email",
        required: true
      },
      {
        name: :age,
        type: :number,
        label: "Age"
      }
    ]
  end
end
```

For more information on creating forms, refer to the lib/bleuprint/forms/base.rb file.

### Fields

Bleuprint provides a wide range of field types that can be used in dashboards and forms. Some of the available field types include:

`Bleuprint::Field::Text`: Represents a text input field.
`Bleuprint::Field::Number`: Represents a number input field.
`Bleuprint::Field::Boolean`: Represents a boolean switch input.
`Bleuprint::Field::Date`: Represents a date input field.
`Bleuprint::Field::Datetime`: Represents a datetime input field.
`Bleuprint::Field::File`: Represents a file upload field.
`Bleuprint::Field::Select`: Represents a select dropdown field.
`Bleuprint::Field::Hidden`: Represents a hidden input field.
Here's an example of defining fields with options:

```ruby
ATTRIBUTE_TYPES = {
  name: Bleuprint::Field::Text,
  email: Bleuprint::Field::Text.with_options(searchable: true),
  age: Bleuprint::Field::Number,
  admin: Bleuprint::Field::Boolean.with_options(label: "Is Admin?")
}.freeze
```

For a comprehensive list of available field types and their usage, refer to the files in the lib/bleuprint/field directory.

### Service Objects

Bleuprint provides base classes for implementing common service patterns, such as creating, updating, and destroying resources using ActiveRecord. Here's an example of a create/update service:

```ruby
# app/services/user_create_update_service.rb
class UserCreateUpdateService < Bleuprint::Services::ActiveRecord::BaseCreateUpdate
  def initialize(user, params, current_user)
    super(user, params, current_user)
  end

  def call!
    super do |user|
      # Custom logic before saving the user
    end
  end
end
```

For more details on using service objects, refer to the files in the lib/bleuprint/services/active_record directory.
