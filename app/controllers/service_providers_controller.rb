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
            redirect_to create_services_path, notice: "Great! Now let's create your services."
        else
            @resource_name = :user

            if @resource.category.present?
                @subcategories = subcategories_for(@resource.category)
            else
                @subcategories = []
            end
            render "service_providers/service_provider_service_type_form"
        end
    end







    def create_services
        @resource = current_user
        services_params = params[:services] || {}
        created_services = []
        errors = []

            services_params.each do |subcategory, service_data|
                next if service_data[:name].blank? || service_data[:price].blank?
                
                service = Service.new(
                    name: service_data[:name],
                    description: service_data[:description],
                    price: service_data[:price],
                    location: service_data[:location],
                    category: @resource.category.parameterize,
                    subcategory: subcategory,
                    provider_id: @resource.id
                )

                if service.save
                    created_services << service
                else
                    errors << "#{subcategory.humanize}: #{service.errors.full_messages.join(', ')}"
                end
            end
        
        if created_services.any?
            if errors.any?
                redirect_to root_path, notice: "#{created_services.count} services created successfully! Some had errors: #{errors.join('; ')}"
            else
                redirect_to root_path, notice: "Congratulations! #{created_services.count} services created successfully. You're all set to receive bookings!"
            end
        else
            @subcategories = @resource.subcategories || []
            @services_data = services_params
            flash.now[:alert] = "Please create at least one service. Errors: #{errors.join('; ')}"
            render "service_providers/create_services_form"
        end
        end


    def create_services_form
        @resource = current_user
        @subcategories = @resource.subcategories || []
        
        # Initialize services hash for the form
        @services_data = {}
        @subcategories.each do |subcategory|
            @services_data[subcategory] = {
                name: "",
                description: "",
                price: "",
                location: @resource.city || ""
            }
        end
        
        render "service_providers/create_services_form"
    end







    def update_subcategories
        @resource = current_user
        @selected_category = params[:category]
        @resource.update(category: @selected_category.parameterize) if @selected_category.present?
        @subcategories = subcategory_names_for(@selected_category)

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
        params.require(:user).permit( :country, :city, :address)
    end
    
    def cities_for(province)
        {
        "Punjab" => [
    "Lahore", "Rawalpindi", "Faisalabad", "Multan", "Gujranwala",
    "Sialkot", "Bahawalpur", "Sargodha", "Sheikhupura", "Rahim Yar Khan",
    "Jhelum", "Gujrat", "Okara", "Dera Ghazi Khan", "Chiniot",
    "Kasur", "Vehari", "Mandi Bahauddin", "Narowal", "Muzaffargarh"
  ],
  "Sindh" => [
    "Karachi", "Hyderabad", "Sukkur", "Larkana", "Nawabshah",
    "Mirpur Khas", "Jacobabad", "Shikarpur", "Dadu", "Kandhkot",
    "Thatta", "Badin", "Khairpur", "Tando Adam", "Tando Allahyar"
  ],
  "Balochistan" => [
    "Quetta", "Gwadar", "Turbat", "Khuzdar", "Sibi",
    "Loralai", "Zhob", "Chaman", "Pishin", "Dera Bugti",
    "Nushki", "Kharan", "Mastung", "Panjgur", "Jiwani"
  ],
  "KPK" => [
    "Peshawar", "Abbottabad", "Swat", "Mardan", "Kohat",
    "Dera Ismail Khan", "Bannu", "Nowshera", "Charsadda", "Haripur",
    "Swabi", "Mansehra", "Dir", "Lakki Marwat", "Hangu"
  ]
        }[province] || []
    end

end
