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

    @booking = Booking.new(booking_params.merge(
      client: current_user,
      service: @service,
      service_provider_id: @service.provider_id,
      price: @service.price,
      status: "pending"
    ))

    if @booking.save
      BookingMailer.new_booking_notification(@booking).deliver_now
      redirect_to booking_path(@booking), notice: "Booking placed successfully! Here are your booking details."
    else
      flash.now[:alert] = "Failed to create booking: #{@booking.errors.full_messages.join(', ')}"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @booking = current_user.bookings.find(params[:id])
    @service = @booking.service
    
    if @booking.status != 'pending'
      redirect_to client_dashboard_path, alert: "You can only edit pending bookings."
      return
    end
  end


  def update
    @booking = current_user.bookings.find(params[:id])
    @service = @booking.service
    
    if @booking.status != 'pending'
      redirect_to client_dashboard_path, alert: "You can only edit pending bookings."
      return
    end
    
    if @booking.update(booking_params)
      redirect_to client_dashboard_path, notice: "Booking updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
      @booking = current_user.bookings.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to client_dashboard_path, alert: "Booking not found."
  end



  def destroy
    @booking = current_user.bookings.find(params[:id])
    
    if ['pending', 'confirmed'].include?(@booking.status)
      @booking.update(status: 'cancelled')
      redirect_to client_dashboard_path, notice: "Booking cancelled successfully."
    else
      redirect_to client_dashboard_path, alert: "Cannot cancel this booking."
    end
  end

  private

  def ensure_client
    redirect_to root_path, alert: "Only clients can book services." unless current_user.is_a?(Client)
  end
  
  def booking_params
    params.require(:booking).permit(:date, :time, :address, :notes)
  end


end
