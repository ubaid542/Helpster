# Searchable Dropdown Implementation

This implementation provides a searchable dropdown functionality for Ruby on Rails applications using ERB templates. It automatically adds a search input above any select element with the `searchable-dropdown` class.

## Features

- ✅ Real-time search filtering
- ✅ Works with any select element
- ✅ Responsive design
- ✅ Dark mode support
- ✅ Turbo-compatible (works with SPA navigation)
- ✅ No external dependencies
- ✅ Easy to implement

## Quick Start

### 1. Basic Usage

Simply add the `searchable-dropdown` class to any select element:

```erb
<%= form.collection_select :service_id, @services, :id, :name, 
    { prompt: "Select a service" }, 
    { class: "searchable-dropdown" } %>
```

### 2. Using Helper Methods

For convenience, you can use the provided helper methods:

```erb
<%= searchable_collection_select form, :service_id, @services, :id, :name, 
    { prompt: "Select a service" } %>

<%= searchable_select form, :category, 
    options_for_select(@categories.map { |cat| [cat, cat] }), 
    { prompt: "Select a category" } %>
```

## Implementation Details

### Files Created/Modified

1. **JavaScript**: `app/javascript/searchable_dropdown.js`
   - Handles the search functionality
   - Automatically initializes on page load and Turbo navigation
   - Creates search input above select elements

2. **CSS**: `app/assets/stylesheets/searchable_dropdown.css`
   - Provides styling for the search input and dropdown
   - Includes responsive design and dark mode support

3. **Helper**: `app/helpers/application_helper.rb`
   - Added convenience methods for creating searchable dropdowns

4. **Import Map**: `config/importmap.rb`
   - Added the searchable dropdown JavaScript to the import map

5. **Application JS**: `app/javascript/application.js`
   - Imports the searchable dropdown functionality

### How It Works

1. **Initialization**: The JavaScript listens for `DOMContentLoaded` and `turbo:load` events
2. **Element Selection**: Finds all elements with the `searchable-dropdown` class
3. **Input Creation**: Dynamically creates a search input above each dropdown
4. **Search Functionality**: Filters dropdown options based on user input
5. **Styling**: Applies consistent styling with focus states and transitions

## Examples

### Service Selection
```erb
<%= form.collection_select :service_id, @services, :id, :name, 
    { prompt: "Select a service" }, 
    { class: "searchable-dropdown" } %>
```

### Category Selection
```erb
<%= form.select :category, 
    options_for_select(@categories.map { |cat| [cat, cat] }), 
    { prompt: "Select a category" }, 
    { class: "searchable-dropdown" } %>
```

### Multiple Dropdowns in a Form
```erb
<%= form_with url: "#", local: true do |form| %>
  <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
    <div>
      <%= form.label :service_id, "Service" %>
      <%= searchable_collection_select form, :service_id, @services, :id, :name %>
    </div>
    
    <div>
      <%= form.label :category, "Category" %>
      <%= searchable_select form, :category, 
          options_for_select(@categories.map { |cat| [cat, cat] }) %>
    </div>
  </div>
<% end %>
```

## Demo

Visit `/searchable_dropdown_demo` to see the implementation in action with various examples.

## Customization

### Styling

You can customize the appearance by modifying the CSS in `app/assets/stylesheets/searchable_dropdown.css`:

```css
.searchable-dropdown-input {
  /* Custom styles for the search input */
}

.searchable-dropdown {
  /* Custom styles for the dropdown */
}
```

### JavaScript Behavior

Modify `app/javascript/searchable_dropdown.js` to change the search behavior:

```javascript
// Change the search logic
searchInput.addEventListener('keyup', function() {
  const filter = searchInput.value.toLowerCase();
  // Custom filtering logic here
});
```

## Browser Compatibility

- ✅ Chrome/Chromium
- ✅ Firefox
- ✅ Safari
- ✅ Edge
- ✅ Mobile browsers (iOS Safari, Chrome Mobile)

## Performance

- Lightweight implementation (~2KB JavaScript)
- No external dependencies
- Efficient DOM manipulation
- Prevents duplicate initialization

## Troubleshooting

### Dropdown not working?
1. Check that the `searchable-dropdown` class is added to your select element
2. Ensure the JavaScript is properly imported in `application.js`
3. Check browser console for any JavaScript errors

### Search not filtering options?
1. Verify the select element has options
2. Check that the search input is being created above the dropdown
3. Ensure the JavaScript is running (check console for initialization messages)

### Styling issues?
1. Make sure the CSS file is being loaded
2. Check for conflicting CSS rules
3. Verify the class names match between HTML and CSS

## Contributing

To extend this implementation:

1. Add new features to `searchable_dropdown.js`
2. Update styles in `searchable_dropdown.css`
3. Add helper methods to `application_helper.rb`
4. Test thoroughly with different select elements and data types

## License

This implementation is part of your Rails application and follows the same license terms.