// Searchable Dropdown Implementation
document.addEventListener('DOMContentLoaded', function() {
  initializeSearchableDropdowns();
});

// Also initialize when Turbo navigates (for SPA-like behavior)
document.addEventListener('turbo:load', function() {
  initializeSearchableDropdowns();
});

function initializeSearchableDropdowns() {
  const dropdowns = document.querySelectorAll('.searchable-dropdown');
  
  dropdowns.forEach(function(dropdown) {
    // Skip if already initialized
    if (dropdown.dataset.searchableInitialized === 'true') {
      return;
    }
    
    // Create search input
    const searchInput = document.createElement('input');
    searchInput.type = 'text';
    searchInput.placeholder = 'Search...';
    searchInput.className = 'searchable-dropdown-input';
    searchInput.style.cssText = `
      margin-bottom: 5px;
      padding: 8px 12px;
      width: 100%;
      border: 1px solid #d1d5db;
      border-radius: 6px;
      font-size: 14px;
      box-sizing: border-box;
    `;
    
    // Insert search input before the dropdown
    dropdown.parentNode.insertBefore(searchInput, dropdown);
    
    // Add search functionality
    searchInput.addEventListener('keyup', function() {
      const filter = searchInput.value.toLowerCase();
      const options = Array.from(dropdown.options);
      
      options.forEach(function(option) {
        const text = option.text.toLowerCase();
        if (text.includes(filter)) {
          option.style.display = '';
        } else {
          option.style.display = 'none';
        }
      });
    });
    
    // Add focus styles
    searchInput.addEventListener('focus', function() {
      this.style.outline = 'none';
      this.style.borderColor = '#3b82f6';
      this.style.boxShadow = '0 0 0 3px rgba(59, 130, 246, 0.1)';
    });
    
    searchInput.addEventListener('blur', function() {
      this.style.borderColor = '#d1d5db';
      this.style.boxShadow = 'none';
    });
    
    // Mark as initialized
    dropdown.dataset.searchableInitialized = 'true';
  });
}

// Export for potential module usage
if (typeof module !== 'undefined' && module.exports) {
  module.exports = { initializeSearchableDropdowns };
}