class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :store_user_location!, if: :storable_location?

 protected

  def after_sign_in_path_for(resource)
    # Return to the stored location if available, otherwise use default logic
    stored_location_for(resource) || default_after_sign_in_path_for(resource)
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  private

  def default_after_sign_in_path_for(resource)
    # Check if they signed up as a client
    if current_user.type == "Client"
      categories_path
    else
      root_path(logged_in: true)
    end
  end

  def storable_location?
    # Only store location for GET requests that are not AJAX requests
    request.get? && !request.xhr? && !devise_controller?
  end

  def store_user_location!
    # Store the current location for redirect after sign in
    store_location_for(:user, request.fullpath)
  end


end
