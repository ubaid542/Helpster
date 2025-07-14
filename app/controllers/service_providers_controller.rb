class ServiceProvidersController < ApplicationController

    before_action :authenticate_user!


    def service_details
        @resource = current_user
        @resource_name = :user
        render "service_providers/service_provider_service_type_form"
    end

    def update_professional_details
        @resource = current_user
        if @resource.update(professional_params)
        redirect_to root_path, notice: "Signup completed successfully!"
        else
        @resource_name = :user
        render "service_providers/service_provider_service_type_form"
        end
    end


    def location_form
        @provinces = ["Punjab", "Sindh", "Balochistan", "KPK"]
        @selected_province = params[:province]
        @cities = cities_for(@selected_province)

        respond_to do |format|
       
            format.turbo_stream do
                render turbo_stream: turbo_stream.replace(
                    "cities_frame",
                    partial: "service_providers/cities_dropdown",
                    locals: { cities: @cities } 
                )
            end
            format.html do
                # For direct access, render with layout
                if request.xhr? || params[:partial]
                    render partial: "service_providers/service_provider_location_form"
                else
                    render "service_providers/location_form"
                end
            end
            
        end
    end

    private

    def professional_params
        params.require(:user).permit(:category, :experience_years, :short_info)
    end
    
    def cities_for(province)
        {
        "Punjab" => ["Lahore", "Rawalpindi", "Faisalabad"],
        "Sindh" => ["Karachi", "Hyderabad", "Sukkur"],
        "Balochistan" => ["Quetta", "Gwadar", "Turbat"],
        "KPK" => ["Peshawar", "Abbottabad", "Swat"]
        }[province] || []
    end

end
