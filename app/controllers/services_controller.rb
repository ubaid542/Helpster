class ServicesController < ApplicationController
  def index
    @category = params[:category]
    @subcategory = params[:subcategory]
    @category_name = @category.humanize.titleize
    @subcategory_name = @subcategory.humanize.titleize
    @services = Service.where(category: @category, subcategory: @subcategory)
  end

  def show
    @service = Service.find(params[:id])
  end
end