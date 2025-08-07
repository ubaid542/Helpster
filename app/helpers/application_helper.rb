module ApplicationHelper
  # Helper method for creating searchable dropdowns
  def searchable_collection_select(form, method, collection, value_method, text_method, options = {}, html_options = {})
    # Merge the searchable-dropdown class with any existing classes
    html_options[:class] = "searchable-dropdown #{html_options[:class]}".strip
    
    form.collection_select(method, collection, value_method, text_method, options, html_options)
  end
  
  # Helper method for creating searchable select dropdowns
  def searchable_select(form, method, choices, options = {}, html_options = {})
    # Merge the searchable-dropdown class with any existing classes
    html_options[:class] = "searchable-dropdown #{html_options[:class]}".strip
    
    form.select(method, choices, options, html_options)
  end
end