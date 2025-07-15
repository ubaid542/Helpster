class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :require_no_authentication, only: [:new, :create]
  before_action :configure_sign_up_params, only: [:create]

  def create
    build_resource(sign_up_params)   # This initializes `resource` with user params

    if resource.save
      sign_up(resource_name, resource)

      if resource.type == "ServiceProvider"
        redirect_to service_provider_details_path(resource)
      else
        redirect_to root_path, notice: "Signed up successfully!"
      end
    else
      clean_up_passwords(resource)
      set_minimum_password_length

      request.env["devise.mapping"] = Devise.mappings[:user]  # 🛠️ Required for Devise form_for
      @resource = resource
      @resource_name = resource_name

      respond_to do |format|
        format.html do
          if resource.type == "ServiceProvider"
            render template: "users/registrations/new"
          else
            render "clients/registrations/client_signup_form"
          end
        end
        format.turbo_stream do
          if resource.type == "ServiceProvider"
            render template: "users/registrations/new"
          else
            render "clients/registrations/client_signup_form"
          end
        end
      end
    end
  end

  def new
    # Sign out current user if they're trying to sign up as a different type
    if user_signed_in?
      sign_out(current_user)
    end

    request.env["devise.mapping"] = Devise.mappings[:user]
    @resource = User.new(type: params[:type])
    @resource_name = :user

    respond_to do |format|
      format.html { render :new }
      format.turbo_stream { render :new }
    end
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name, :phone_number, :type])
  end
end















# # frozen_string_literal: true

# class Users::RegistrationsController < Devise::RegistrationsController
#   before_action :configure_sign_up_params, only: [:create]
#   # before_action :configure_account_update_params, only: [:update]


#   def create
#     build_resource(sign_up_params)   # This initializes `resource` with user params

#     if resource.save
#       sign_up(resource_name, resource)

#       if resource.type == "ServiceProvider"
#         redirect_to service_provider_details_path(resource)
#       else
#         redirect_to root_path, notice: "Signed up successfully!"
#       end
#     else
#       clean_up_passwords(resource)
#       set_minimum_password_length

#       request.env["devise.mapping"] = Devise.mappings[:user]  # 🛠️ Required for Devise form_for
#       @resource = resource
#       @resource_name = resource_name

#       if resource.type == "ServiceProvider"
#         render template: "users/registrations/new"
#       else
#         render "clients/registrations/client_signup_form"
#       end
#     end
#   end



#   def new
#   request.env["devise.mapping"] = Devise.mappings[:user]
#   @resource = User.new(type: params[:type])
#   @resource_name = :user

#   render :new
# end

#   protected

# def configure_sign_up_params
#   devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name, :phone_number, :type])
# end

  


  

#   # POST /resource
#   # def create
#   #   super
#   # end

#   # GET /resource/edit
#   # def edit
#   #   super
#   # end

#   # PUT /resource
#   # def update
#   #   super
#   # end

#   # DELETE /resource
#   # def destroy
#   #   super
#   # end

#   # GET /resource/cancel
#   # Forces the session data which is usually expired after sign
#   # in to be expired now. This is useful if the user wants to
#   # cancel oauth signing in/up in the middle of the process,
#   # removing all OAuth session data.
#   # def cancel
#   #   super
#   # end

#   # protected

#   # If you have extra params to permit, append them to the sanitizer.
#   # def configure_sign_up_params
#   #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
#   # end

#   # If you have extra params to permit, append them to the sanitizer.
#   # def configure_account_update_params
#   #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
#   # end

#   # The path used after sign up.
#   # def after_sign_up_path_for(resource)
#   #   super(resource)
#   # end

#   # The path used after sign up for inactive accounts.
#   # def after_inactive_sign_up_path_for(resource)
#   #   super(resource)
#   # end
# end
