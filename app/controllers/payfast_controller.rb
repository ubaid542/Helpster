class PayfastController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:notify]

  def return
    order_id = params[:order_id]
    status = params[:status]
    transaction_id = params[:transaction_id]
    
    if status == 'success' || status == 'completed'
      # Extract booking ID from order_id (format: BOOKING_123)
      if order_id && order_id.start_with?('BOOKING_')
        booking_id = order_id.gsub('BOOKING_', '')
        booking = Booking.find_by(id: booking_id)
        
        if booking
          booking.update(
            payment_status: 'paid',
            payment_reference: transaction_id,
            paid_at: Time.current
          )
        end
      end
      
      flash[:success] = "Payment completed successfully! Transaction ID: #{transaction_id}"
    else
      flash[:alert] = 'Payment was not successful.'
    end
    
    redirect_to client_dashboard_path
  end

  def cancel
    flash[:alert] = 'Payment was cancelled. You can try again anytime.'
    redirect_to client_dashboard_path
  end

  def notify
    Rails.logger.info "PayFast notification received: #{params.inspect}"
    
    # Validate signature
    received_signature = params[:signature]
    validation_params = params.except(:signature, :controller, :action)
    param_string = validation_params.sort.map { |k, v| "#{k}=#{v}" }.join('&')
    expected_signature = Digest::MD5.hexdigest(param_string)
    
    if received_signature == expected_signature
      if params[:status] == 'completed' || params[:status] == 'success'
        # Extract booking ID from order_id
        if params[:order_id] && params[:order_id].start_with?('BOOKING_')
          booking_id = params[:order_id].gsub('BOOKING_', '')
          booking = Booking.find_by(id: booking_id)
          
          if booking
            booking.update!(
              payment_status: 'paid',
              payment_reference: params[:transaction_id],
              paid_at: Time.current
            )
            Rails.logger.info "Payment completed for booking #{booking.id}, Transaction: #{params[:transaction_id]}"
          end
        end
      end
      render plain: 'OK'
    else
      Rails.logger.error "Invalid signature in PayFast notification"
      render plain: 'Invalid signature', status: 400
    end
  rescue => e
    Rails.logger.error "PayFast notification error: #{e.message}"
    render plain: 'Error', status: 500
  end
end