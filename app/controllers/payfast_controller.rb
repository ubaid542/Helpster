class PayfastController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:notify]

  def return
    # JazzCash return parameters
    response_code = params[:pp_ResponseCode]
    response_message = params[:pp_ResponseMessage]
    transaction_id = params[:pp_RetreivalReferenceNo]
    bill_reference = params[:pp_BillReference]
    
    if response_code == '000' # JazzCash success code
      # Extract booking ID from bill_reference (format: BOOKING_123)
      if bill_reference && bill_reference.start_with?('BOOKING_')
        booking_id = bill_reference.gsub('BOOKING_', '')
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
      flash[:alert] = "Payment failed: #{response_message}"
    end
    
    redirect_to client_dashboard_path
  end

  def cancel
    flash[:alert] = 'Payment was cancelled. You can try again anytime.'
    redirect_to client_dashboard_path
  end

  def notify
    Rails.logger.info "JazzCash notification received: #{params.inspect}"
    
    # Validate JazzCash secure hash
    received_hash = params[:pp_SecureHash]
    secured_key = ENV['JAZZCASH_SECURED_KEY'] || 'TestSecuredKey'
    
    # Prepare data for hash validation (exclude pp_SecureHash)
    validation_params = params.except(:pp_SecureHash, :controller, :action)
    sorted_string = validation_params.sort.map { |k, v| "#{k}=#{v}" }.join('&')
    hash_string = "#{sorted_string}&#{secured_key}"
    expected_hash = Digest::SHA256.hexdigest(hash_string)
    
    if received_hash == expected_hash
      if params[:pp_ResponseCode] == '000' # JazzCash success code
        # Extract booking ID from bill_reference
        if params[:pp_BillReference] && params[:pp_BillReference].start_with?('BOOKING_')
          booking_id = params[:pp_BillReference].gsub('BOOKING_', '')
          booking = Booking.find_by(id: booking_id)
          
          if booking
            booking.update!(
              payment_status: 'paid',
              payment_reference: params[:pp_RetreivalReferenceNo],
              paid_at: Time.current
            )
            Rails.logger.info "Payment completed for booking #{booking.id}, Transaction: #{params[:pp_RetreivalReferenceNo]}"
          end
        end
      end
      render plain: 'OK'
    else
      Rails.logger.error "Invalid secure hash in JazzCash notification"
      render plain: 'Invalid hash', status: 400
    end
  rescue => e
    Rails.logger.error "JazzCash notification error: #{e.message}"
    render plain: 'Error', status: 500
  end
end