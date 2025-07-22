class CategoriesController < ApplicationController
  include ServiceProvidersHelper

  def index
  end

  def show
    @category = params[:category]
    @category_name = @category.humanize.titleize
    
    # Convert URL parameter to match helper format
    category_key = case @category
    when 'electrician' then 'Electrician'
    when 'plumber' then 'Plumber'
    when 'house-cleaner' then 'House Cleaner'
    when 'mechanic' then 'Mechanic'
    when 'carpenter' then 'Carpenter'
    when 'painter' then 'Painter'
    when 'gardener' then 'Gardener'
    else @category.humanize.titleize
    end
    
    @subcategories = subcategories_for(category_key)
  end
end