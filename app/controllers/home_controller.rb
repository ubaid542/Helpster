
class HomeController < ApplicationController
  def index
    # Check if user just logged in
      @just_logged_in = params[:logged_in] == 'true'
      @users = User.order(created_at: :desc)
  end

  def all_users
    @users = User.order(created_at: :desc)
  end
  
end
