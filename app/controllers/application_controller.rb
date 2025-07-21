class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  protected

  def after_sign_in_path_for(resource)
    # Redirect to root with success parameter after login
    root_path(logged_in: true)
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end
