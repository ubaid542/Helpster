class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :require_no_authentication, only: [:new, :create]
  before_action :configure_sign_up_params, only: [:create]

  def create
    build_resource(sign_up_params)   # This initializes `resource` with user params

    if resource.save
      sign_up(resource_name, resource)
      
      setup_location_form_variables
      
      if resource.type == "ServiceProvider"
        respond_to do |format|
          format.html { redirect_to location_form_path }
          format.turbo_stream { 
            render turbo_stream: turbo_stream.replace(
              "signup_section", 
              partial: "service_providers/location_form"
            )
          }
        end
      else
        respond_to do |format|
          format.html { redirect_to root_path, notice: "Welcome! Account created successfully." }
          format.turbo_stream { redirect_to root_path, notice: "Welcome! Account created successfully." }
        end
      end
      
    else
      clean_up_passwords(resource)
      set_minimum_password_length

      request.env["devise.mapping"] = Devise.mappings[:user]  # 🛠️ Required for Devise form_for
      @resource = resource
      @resource_name = resource_name

      render :new
    end
  end

  def new
    

    request.env["devise.mapping"] = Devise.mappings[:user]
    @resource = User.new(type: params[:type])
    @resource_name = :user

    respond_to do |format|
      format.html { render :new }
      format.turbo_stream { render :new }
    end
  end


  private

  def setup_location_form_variables
    @resource = current_user
    @provinces = ["Punjab", "Sindh", "Balochistan", "KPK"]
    @selected_province = @resource.province
    @cities = cities_for(@selected_province)
  end

  def cities_for(province)
    {
      "Punjab" => ["Lahore", "Rawalpindi", "Faisalabad"],
      "Sindh" => ["Karachi", "Hyderabad", "Sukkur"],
      "Balochistan" => ["Quetta", "Gwadar", "Turbat"],
      "KPK" => ["Peshawar", "Abbottabad", "Swat"]
    }[province] || []
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name, :phone_number, :type])
  end
end
