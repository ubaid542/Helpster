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

    @booking = Booking.new(
      client: current_user,
      service: @service,
      service_provider_id: @service.provider_id,  
      date: params[:booking][:date],
      time: params[:booking][:time],
      address: params[:booking][:address],
      notes: params[:booking][:notes],
      price: @service.price,
      status: "pending"
    )

    if @booking.save
      redirect_to root_path, notice: "Booking placed successfully."
    else
      puts "🚨 Booking failed: #{@booking.errors.full_messages}"
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
