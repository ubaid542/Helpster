class BookingMailer < ApplicationMailer
  default from: 'ranaubaid542@gmail.com'

  def new_booking_notification(booking)
    @booking = booking
    @service_provider = booking.service_provider
    @client = booking.client
    @service = booking.service

    mail(
      to: @service_provider.email,
      subject: "New Booking Request - #{@service.name}"
    )
  end
end