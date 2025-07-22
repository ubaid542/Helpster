class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

 protected

  def after_sign_in_path_for(resource)
    # Check if they signed up as a client
    if current_user.type == "Client"
      categories_path
    else
      root_path(logged_in: true)
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end


end
