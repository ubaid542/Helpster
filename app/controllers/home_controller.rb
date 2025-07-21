
class HomeController < ApplicationController
  def index
    # Check if user just logged in
    @just_logged_in = params[:logged_in] == 'true'
  end
end

