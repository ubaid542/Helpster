
class HomeController < ApplicationController
  def index
    # Check if user just logged in
      @just_logged_in = params[:logged_in] == 'true'
      @users = User.order(created_at: :desc)

      # Add these two lines:
  @service_options = prepare_service_options
  @location_options = prepare_location_options
  end

  def all_users
    @users = User.order(created_at: :desc)
  end

  def search
    @query = params[:q]&.strip
    @location = params[:location]&.strip

    @service_options = prepare_service_options
  @location_options = prepare_location_options
    
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
  private

def prepare_service_options
  Service.distinct.pluck(:name).compact.sort.map { |name| [name, name] }
end

def prepare_location_options
  Service.distinct.pluck(:location).compact.sort.map { |loc| [loc, loc] }
end
  
end
