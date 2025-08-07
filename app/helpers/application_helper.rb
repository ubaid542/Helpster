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
  
  # Debug helper to show stored location (only in development)
  def debug_stored_location
    if Rails.env.development? && session[:user_return_to].present?
      content_tag :div, class: "bg-yellow-100 border border-yellow-400 text-yellow-700 px-4 py-3 rounded mb-4" do
        "Stored location: #{session[:user_return_to]}"
      end
    end
  end
end