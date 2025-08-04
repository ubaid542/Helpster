
class HomeController < ApplicationController
  def index
    # Check if user just logged in
      @just_logged_in = params[:logged_in] == 'true'
      @users = User.order(created_at: :desc)
  end

  def all_users
    @users = User.order(created_at: :desc)
  end

  def search
    @query = params[:q]&.strip
    @location = params[:location]&.strip
    
    # Search if either query OR location is present
    if @query.present? || @location.present?
      @services = Service.search(@query, @location)
      @search_performed = true
    else
      @services = Service.none
      @search_performed = false
    end
    
    # Count for display
    @total_results = @services.count
    
    # Set search type for display messages
    @search_type = if @query.present? && @location.present?
                    'both'
                  elsif @query.present?
                    'service'
                  elsif @location.present?
                    'location'
                  else
                    'none'
                  end
  end



  
  def search_suggestions
    query = params[:q]&.strip
    location = params[:location]&.strip
    
    suggestions = []
    
    if query.present? && query.length >= 2
      # Get service name suggestions
      service_names = Service.where("name ILIKE ?", "%#{query}%")
                            .limit(5)
                            .pluck(:name)
                            .uniq
      
      # Get category suggestions
      categories = Service.where("category ILIKE ?", "%#{query}%")
                        .limit(3)
                        .pluck(:category)
                        .uniq
      
      # Get subcategory suggestions
      subcategories = Service.where("subcategory ILIKE ?", "%#{query}%")
                            .limit(3)
                            .pluck(:subcategory)
                            .uniq
      
      # Combine suggestions with types
      service_names.each { |name| suggestions << { text: name, type: 'service' } }
      categories.each { |cat| suggestions << { text: cat, type: 'category' } }
      subcategories.each { |sub| suggestions << { text: sub, type: 'subcategory' } }
      
      # Remove duplicates and limit total results
      suggestions = suggestions.uniq { |s| s[:text] }.first(8)
    end
    
    if location.present? && location.length >= 2
      # Get location suggestions
      locations = Service.where("location ILIKE ?", "%#{location}%")
                        .limit(5)
                        .pluck(:location)
                        .uniq
      
      location_suggestions = locations.map { |loc| { text: loc, type: 'location' } }
      
      render json: { 
        query_suggestions: suggestions,
        location_suggestions: location_suggestions
      }
    else
      render json: { 
        query_suggestions: suggestions,
        location_suggestions: []
      }
    end
  end
  
end
