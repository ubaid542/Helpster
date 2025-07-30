class ClientDashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_client
  
  def index
    @bookings = Booking.where(client_id: current_user.id).includes(:service, :service_provider).order(created_at: :desc)
  end
  
  private
  
  def ensure_client
    redirect_to root_path, alert: "Access denied." unless current_user.type == "Client"
  end
end