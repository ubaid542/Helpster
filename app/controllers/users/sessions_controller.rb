# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  def new
    self.resource = resource_class.new(sign_in_params)
    respond_with(resource) do
      render "clients/registrations/service_provider_signup_form"
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
