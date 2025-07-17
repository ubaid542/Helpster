class ServiceProvidersController < ApplicationController
    include ServiceProvidersHelper
    before_action :authenticate_user!


   
    def service_details
        @resource = current_user
        @resource_name = :user
        
        # Load existing subcategories if category is already set
        if @resource.category.present?
            @subcategories = subcategories_for(@resource.category)
        else
            @subcategories = []
        end
        
        render "service_providers/service_provider_service_type_form"
    end

    def update_professional_details
        @resource = current_user
        if @resource.update(professional_params)
            redirect_to root_path, notice: "Profile setup completed successfully! Welcome to Helpster!"
        else
            @resource_name = :user
            # Reload subcategories if there are validation errors
            if @resource.category.present?
                @subcategories = subcategories_for(@resource.category)
            else
                @subcategories = []
            end
            render "service_providers/service_provider_service_type_form"
        end
    end


    def update_subcategories
        @resource = current_user
        @selected_category = params[:category]
        @resource.update(category: @selected_category) if @selected_category.present?
        @subcategories = subcategories_for(@selected_category)

        respond_to do |format|
            format.turbo_stream do
                render turbo_stream:
                    turbo_stream.replace(
                        "subcategories_frame",
                        partial: "service_providers/service_provider_service_subcategory",
                        locals: { subcategories: @subcategories }
                    )
                
            end
        end
    end



    

    def location_form
        @resource = current_user  
        @provinces = ["Punjab", "Sindh", "Balochistan", "KPK"]
        if params[:province].present?
            current_user.update(province: params[:province])  
        end
        @selected_province = current_user.province
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
                render "service_providers/_location_form"
            end
            
        end
    end

    def update_location
        @resource = current_user

        if @resource.update(location_params)
            # redirect_to service_provider_details_path, notice: "Location saved! Now let's set up your professional details."
            respond_to do |format|
                format.turbo_stream do
                    render turbo_stream: turbo_stream.replace(
                        "signup_section",
                        partial: "service_providers/service_provider_service_type_form"
                    )
                end
            end
        else
            @provinces = ["Punjab", "Sindh", "Balochistan", "KPK"]
            @selected_province = params[:user][:province]
            @cities = cities_for(@selected_province)
            
            render partial: "service_providers/service_provider_location_form"
        end
        
    end


    def professional_params
        params.require(:user).permit(:experience_years, :short_info, subcategories: [])
    end

   

    

    def location_params
        params.require(:user).permit( :city, :address)
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
