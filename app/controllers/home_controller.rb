class HomeController < ApplicationController
  def index
    # request.env["devise.mapping"] = Devise.mappings[:user]
    #   @resource = User.new
    #   @resource_name = :user
    
    # # Add these for the location form partial to work without errors:
    # @provinces = ["Punjab", "Sindh", "Balochistan", "KPK"]
    # @selected_province = params[:province]
    # @cities = if @selected_province.present?
    #             cities_for(@selected_province)
    #           else
    #             []
    #           end
  end

#   private

#   def cities_for(province)
#     {
#       "Punjab" => ["Lahore", "Rawalpindi", "Faisalabad"],
#       "Sindh" => ["Karachi", "Hyderabad", "Sukkur"],
#       "Balochistan" => ["Quetta", "Gwadar", "Turbat"],
#       "KPK" => ["Peshawar", "Abbottabad", "Swat"]
#     }[province] || []
#   end
end
