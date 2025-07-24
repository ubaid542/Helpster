class ServicesController < ApplicationController
  include ServiceProvidersHelper

  def index
    @category = params[:category]
    @subcategory = params[:subcategory]
    @category_name = @category.humanize.titleize
    @subcategory_name = @subcategory.humanize.titleize
    
    # Convert URL parameters to match database format
    db_category = convert_category_from_url(@category)
    db_subcategory = convert_subcategory_from_slug(@category, @subcategory)
    
    # Fix N+1 query by preloading provider association
    @services = Service.where(category: db_category, subcategory: db_subcategory)
                      .includes(:provider)
                      .order(created_at: :desc)
  end

  def show
    @service = Service.find(params[:id])
  end

  private

  def convert_category_from_url(category_url)
    case category_url
    when 'electrician' then 'Electrician'
    when 'plumber' then 'Plumber'
    when 'house-cleaner' then 'House Cleaner'
    when 'mechanic' then 'Mechanic'
    when 'carpenter' then 'Carpenter'
    when 'painter' then 'Painter'
    when 'gardener' then 'Gardener'
    else category_url.humanize.titleize
    end
  end

  def convert_subcategory_from_slug(category_url, subcategory_slug)
    db_category = convert_category_from_url(category_url)
    subcategory_data = find_subcategory_by_slug(db_category, subcategory_slug)
    subcategory_data ? subcategory_data[:name] : subcategory_slug.humanize.titleize
  end
end