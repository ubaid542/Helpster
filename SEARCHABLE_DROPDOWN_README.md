# Searchable Dropdown Component for Rails ERB

A modern, accessible searchable dropdown component built with Stimulus and ERB for Ruby on Rails applications.

## Features

- ✅ Real-time search and filtering
- ✅ Keyboard navigation (Arrow keys, Enter, Escape)
- ✅ Click outside to close
- ✅ Mobile responsive design
- ✅ Accessible with ARIA attributes
- ✅ Works with Rails form helpers and validations
- ✅ Supports ActiveRecord collections and static arrays
- ✅ Dark mode support
- ✅ Custom styling options

## Installation & Setup

### 1. Files Created

The implementation includes these files:

```
app/javascript/controllers/searchable_dropdown_controller.js  # Stimulus controller
app/assets/stylesheets/searchable_dropdown.css              # CSS styles
app/views/shared/_searchable_dropdown.html.erb              # Reusable partial
app/views/shared/_searchable_dropdown_example.html.erb      # Usage examples
```

### 2. Application Layout Update

The CSS has been automatically included in your `app/views/layouts/application.html.erb`:

```erb
<%= stylesheet_link_tag "searchable_dropdown", "data-turbo-track": "reload" %>
```

### 3. Verify Stimulus Setup

Ensure your Rails app has Stimulus configured. Check that these files exist:
- `config/importmap.rb` (should pin Stimulus)
- `app/javascript/application.js` (should import controllers)

## Usage

### Basic Usage with Partial

```erb
<%= render 'shared/searchable_dropdown',
    form: form,
    attribute: :category_id,
    collection: @categories,
    value_method: :id,
    text_method: :name,
    prompt: "Select a category",
    placeholder: "Search categories...",
    empty_message: "No categories found" %>
```

### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `form` | FormBuilder | Yes | - | Rails form object |
| `attribute` | Symbol | Yes | - | Form attribute name |
| `collection` | Array/ActiveRecord | Yes | - | Data collection |
| `value_method` | Symbol | No | `:id` | Method for option values |
| `text_method` | Symbol | No | `:name` | Method for option text |
| `prompt` | String | No | "Select an option" | Default prompt text |
| `placeholder` | String | No | "Search..." | Search input placeholder |
| `empty_message` | String | No | "No results found" | No results message |
| `html_options` | Hash | No | `{}` | Additional HTML attributes |

### Examples

#### 1. ActiveRecord Collection

```erb
<%= render 'shared/searchable_dropdown',
    form: form,
    attribute: :user_id,
    collection: User.all,
    value_method: :id,
    text_method: :email,
    placeholder: "Type to search users..." %>
```

#### 2. Static Array with OpenStruct

```erb
<%
  priorities = [
    OpenStruct.new(id: 'low', name: 'Low Priority'),
    OpenStruct.new(id: 'high', name: 'High Priority')
  ]
%>

<%= render 'shared/searchable_dropdown',
    form: form,
    attribute: :priority,
    collection: priorities,
    placeholder: "Search priorities..." %>
```

#### 3. Manual HTML Implementation

```erb
<div data-controller="searchable-dropdown" 
     data-searchable-dropdown-placeholder-value="Search..." 
     data-searchable-dropdown-empty-message-value="No results">
  
  <%= form.select :attribute_name, 
                  options_for_select([['Option 1', 'value1'], ['Option 2', 'value2']]), 
                  { prompt: "Select an option" },
                  { "data-searchable-dropdown-target": "select" } %>
</div>
```

## Keyboard Navigation

- **Arrow Down/Up**: Navigate through options
- **Enter**: Select highlighted option
- **Escape**: Close dropdown and blur input
- **Type**: Filter options in real-time

## Styling Customization

### CSS Classes

- `.searchable-dropdown-wrapper`: Main container
- `.searchable-dropdown-input`: Search input field
- `.searchable-dropdown-container`: Dropdown container
- `.searchable-dropdown-option`: Individual option
- `.searchable-dropdown-empty`: Empty state message

### Custom Styling Example

```css
/* Custom styles for specific dropdowns */
.user-selector .searchable-dropdown-input {
  border-color: #10b981;
}

.user-selector .searchable-dropdown-option.selected {
  background-color: #10b981;
}
```

## Browser Support

- ✅ Chrome 60+
- ✅ Firefox 55+
- ✅ Safari 12+
- ✅ Edge 79+
- ⚠️ IE11+ (with polyfills)

## Accessibility

The component includes:
- Proper focus management
- Keyboard navigation
- Screen reader support
- ARIA attributes (can be enhanced further)

## Advanced Configuration

### Form Validation

The component works seamlessly with Rails validations:

```ruby
class MyModel < ApplicationRecord
  validates :category_id, presence: true
end
```

### Custom Event Handling

Listen for change events on the original select:

```javascript
document.addEventListener('DOMContentLoaded', function() {
  const select = document.querySelector('[data-searchable-dropdown-target="select"]');
  select.addEventListener('change', function(event) {
    console.log('Selected value:', event.target.value);
  });
});
```

## Troubleshooting

### Common Issues

1. **Dropdown not appearing**: Check CSS is loaded and no conflicting z-index values
2. **Search not working**: Verify Stimulus controller is loaded
3. **Styling issues**: Check for CSS conflicts with other frameworks

### Debug Mode

Add this to your controller for debugging:

```javascript
// In searchable_dropdown_controller.js
connect() {
  console.log('Searchable dropdown connected', this.element);
  // ... rest of connect method
}
```

## Performance Considerations

- For large datasets (1000+ items), consider server-side filtering
- Use pagination or virtualization for very large collections
- Debounce search input for remote data sources

## Contributing

To extend this component:

1. Modify the Stimulus controller for new features
2. Update CSS for styling changes
3. Test across different browsers and devices
4. Update this documentation

## License

This component is provided as-is for your Rails application. Feel free to modify and distribute according to your project's license.

---

**Need help?** Check the example file at `app/views/shared/_searchable_dropdown_example.html.erb` for complete working examples.