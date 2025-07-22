# app/controllers/bookings_controller.rb
class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_client

   def new
    @service = Service.find(params[:service_id])
    @booking = Booking.new
  end
  
  def create
    @service = Service.find(params[:service_id])
    
    # Build booking with strong parameters
    @booking = Booking.new(booking_params.merge(
      client: current_user,
      service: @service,
      service_provider_id: @service.provider_id,
      price: @service.price,
      status: "pending"
    ))

    if @booking.save
      redirect_to root_path, notice: "Booking placed successfully."
    else
      # Enhanced error logging and user feedback
      Rails.logger.error "🚨 Booking failed: #{@booking.errors.full_messages.join(', ')}"
      Rails.logger.error "🚨 Booking params: #{booking_params.inspect}"
      Rails.logger.error "🚨 Service: #{@service.inspect}"
      Rails.logger.error "🚨 Current user: #{current_user.inspect}"
      
      flash.now[:alert] = "Failed to create booking: #{@booking.errors.full_messages.join(', ')}"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @booking = current_user.bookings.find(params[:id])
    @booking.destroy
    redirect_to root_path, notice: "Booking cancelled successfully."
  end

  private

  def ensure_client
    redirect_to root_path, alert: "Only clients can book services." unless current_user.is_a?(Client)
  end
  
  def booking_params
    params.require(:booking).permit(:date, :time, :address, :notes)
  end
end
