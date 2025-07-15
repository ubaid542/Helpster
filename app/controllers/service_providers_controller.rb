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


    def subcategories_for(category)
    {
        "Electrician" => ["Wiring", "Lighting", "Fan Installation"],
        "Plumber" => ["Leak Fixing", "Pipe Installation", "Water Tank Repair"],
        "Mechanic" => ["Engine Repair", "Oil Change", "Tire Replacement"],
        "House Cleaner" => ["car washer", "Carpet Cleaner", "Tire Replacement"],
        "Carpenter" => ["Engine Repair", "Oil Change", "Tire Replacement"],
        "Painter" => ["Engine Repair", "Oil Change", "Tire Replacement"],
        "Gardener" => ["Engine Repair", "Oil Change", "Tire Replacement"]
        
    }[category] || []
    end

    def update_subcategories
        @subcategories = subcategories_for(params[:category])

        respond_to do |format|
            format.turbo_stream do
            render turbo_stream: turbo_stream.replace(
                "subcategories_frame",
                partial: "service_providers/service_provider_service_subcategory",
                locals: { subcategories: @subcategories }
            )
            end
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
                render partial: "service_providers/service_provider_location_form"
            end
            
        end
    end

    def update_location
        @resource = current_user
        
        if @resource.update(location_params)
            redirect_to root_path, notice: "Location updated successfully!"
        else
            @provinces = ["Punjab", "Sindh", "Balochistan", "KPK"]
            @selected_province = params[:user][:province]
            @cities = cities_for(@selected_province)
            
            render partial: "service_providers/service_provider_location_form"
        end
    end



    private

    def professional_params
        params.require(:user).permit(:category, :experience_years, :short_info)
    end

    def location_params
        params.require(:user).permit(:province, :city, :address)
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
