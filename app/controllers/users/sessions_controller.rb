# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  def new
    self.resource = resource_class.new(sign_in_params)
    
    respond_to do |format|
      format.html { render :new }
      format.turbo_stream { render :new }
    end
  end

  def create
    self.resource = warden.authenticate!(auth_options)
    
    if resource
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      
      respond_to do |format|
        format.html { redirect_to after_sign_in_path_for(resource) }
        format.turbo_stream { redirect_to after_sign_in_path_for(resource) }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.turbo_stream { render :new }
      end
    end
  end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
