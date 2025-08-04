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

  def edit 
    @service = Service.find(params[:id])
  end

  def update
    @service = Service.find(params[:id])
    if @service.update(service_params)
      redirect_to provider_dashboard_path, notice: 'Service updated successfully!'
    else
      render :edit
    end
  end

  def destroy
    @service = Service.find(params[:id])
    @service.destroy
    redirect_to provider_dashboard_path, notice: 'Service deleted successfully!'
  end

  private

  def service_params
    params.require(:service).permit(:name, :description, :price, :location, :status)
  end
end