class Users::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]


  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    
    # Set up necessary variables for the view
    request.env["devise.mapping"] = Devise.mappings[:user]
    @resource = resource
    @resource_name = resource_name
    
    respond_to do |format|
      format.html { render "users/sessions/new" }
      format.turbo_stream { render "users/sessions/new" }
    end
  end

  def create
    self.resource = warden.authenticate(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    respond_with resource, location: after_sign_in_path_for(resource)
  rescue => e
    # Handle failed authentication
    self.resource = resource_class.new(sign_in_params)
    resource.errors.add(:base, "Invalid email or password")
    
    # Set up necessary variables for the view
    request.env["devise.mapping"] = Devise.mappings[:user]
    @resource = resource
    @resource_name = resource_name
    
    respond_to do |format|
      format.html { render "users/sessions/new" }
      format.turbo_stream { render "users/sessions/new" }
    end
  end

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
  end

  def sign_in_params
    params.permit(:email, :password)
  end

end


