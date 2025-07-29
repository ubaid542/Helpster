class PayfastController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:notify]
  require 'net/http'
  require 'uri'
  require 'json'

  def initiate
    @booking = Booking.find(params[:id])
    
    # Redirect to PayFast payment form to collect customer details
    redirect_to payfast_payment_form_path(@booking)
  end
  
  def payment_form
    @booking = Booking.find(params[:id])
  end
  
  def process_payment
    @booking = Booking.find(params[:booking_id])
    
    Rails.logger.info "=== PayFast Process Payment Debug ==="
    Rails.logger.info "Booking ID: #{@booking.id}"
    Rails.logger.info "Form params: #{params.inspect}"
    
    # Get PayFast access token
    Rails.logger.info "Getting PayFast token..."
    token_response = get_payfast_token
    
    Rails.logger.info "Token response: #{token_response.inspect}"
    
    unless token_response && token_response['access_token']
      Rails.logger.error "Failed to get PayFast token"
      flash[:alert] = "Payment system error. Please try again."
      redirect_to dashboard_path and return
    end
    
    # Validate customer details with PayFast
    validation_response = validate_customer_details(token_response['access_token'])
    
    if validation_response && validation_response['success']
      # Redirect to OTP verification
      session[:payfast_token] = token_response['access_token']
      session[:booking_id] = @booking.id
      session[:customer_details] = {
        bank_code: params[:bank_code],
        account_number: params[:account_number],
        cnic_number: params[:cnic_number],
        mobile_no: params[:customer_mobile_no]
      }
      
      redirect_to payfast_otp_verification_path(@booking)
    else
      flash[:alert] = "Customer validation failed. Please check your details."
      redirect_to payfast_payment_form_path(@booking)
    end
  end
  
  def otp_verification
    @booking = Booking.find(params[:id])
    
    unless session[:payfast_token] && session[:booking_id] == @booking.id.to_s
      flash[:alert] = "Session expired. Please start payment process again."
      redirect_to payfast_payment_form_path(@booking) and return
    end
  end
  
  def verify_otp
    @booking = Booking.find_by(id: session[:booking_id])
    
    unless @booking && session[:payfast_token]
      flash[:alert] = "Session expired. Please start payment process again."
      redirect_to dashboard_path and return
    end
    
    # Process payment with OTP
    payment_response = process_payment_with_otp(
      session[:payfast_token],
      params[:otp_code]
    )
    
    if payment_response && payment_response['success']
      # Update booking payment status
      @booking.update!(
        payment_status: 'paid',
        payment_reference: payment_response['transaction_id'],
        paid_at: Time.current
      )
      
      # Clear session
      session.delete(:payfast_token)
      session.delete(:booking_id)
      session.delete(:customer_details)
      
      flash[:success] = "Payment completed successfully! Transaction ID: #{payment_response['transaction_id']}"
      redirect_to dashboard_path
    else
      flash[:alert] = "Payment failed. Please try again or contact support."
      redirect_to payfast_otp_verification_path(@booking)
    end
  end

  def return
    # PayFast return parameters
    response_code = params[:response_code]
    response_message = params[:response_message] 
    transaction_id = params[:transaction_id]
    order_id = params[:order_id]
    
    if response_code == '00' # PayFast success code
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
      flash[:alert] = "Payment failed: #{response_message}"
    end
    
    redirect_to dashboard_path
  end

  def cancel
    flash[:alert] = 'Payment was cancelled. You can try again anytime.'
    redirect_to dashboard_path
  end

  def notify
    Rails.logger.info "PayFast notification received: #{params.inspect}"
    
    # Validate PayFast secure hash
    received_hash = params[:secure_hash]
    secured_key = ENV['PAYFAST_SECURED_KEY'] || 'k0S7IvCjSrX3NCkrYJCei0ac'
    
    # Prepare data for hash validation (exclude secure_hash)
    validation_params = params.except(:secure_hash, :controller, :action)
    sorted_string = validation_params.sort.map { |k, v| "#{k}=#{v}" }.join('&')
    hash_string = "#{sorted_string}&#{secured_key}"
    expected_hash = Digest::SHA256.hexdigest(hash_string)
    
    if received_hash == expected_hash
      if params[:response_code] == '00' # PayFast success code
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
      Rails.logger.error "Invalid secure hash in PayFast notification"
      render plain: 'Invalid hash', status: 400
    end
  rescue => e
    Rails.logger.error "PayFast notification error: #{e.message}"
    render plain: 'Error', status: 500
  end

  private

  def get_payfast_token
    begin
      Rails.logger.info "Requesting PayFast token from: https://gopayfast.com/token"
      
      uri = URI('https://gopayfast.com/token')
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      
      request = Net::HTTP::Post.new(uri)
      request['Content-Type'] = 'application/json'
      request['Accept'] = 'application/json'
      
      # PayFast credentials
      merchant_id = ENV['PAYFAST_MERCHANT_ID'] || '110515'
      secured_key = ENV['PAYFAST_SECURED_KEY'] || 'k0S7IvCjSrX3NCkrYJCei0ac'
      
      request.body = {
        merchant_id: merchant_id,
        secured_key: secured_key,
        source_ip: self.request.remote_ip || '127.0.0.1'  # Fixed: use Rails request object
      }.to_json
      
      response = http.request(request)
      
      if response.code == '200'
        JSON.parse(response.body)
      else
        Rails.logger.error "PayFast token request failed: #{response.code} - #{response.body}"
        nil
      end
    rescue => e
      Rails.logger.error "PayFast token error: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      nil
    end
  end
  
  def validate_customer_details(access_token)
    begin
      uri = URI('https://gopayfast.com/customer/validate')
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      
      request = Net::HTTP::Post.new(uri)
      request['Content-Type'] = 'application/json'
      request['Accept'] = 'application/json'
      request['Authorization'] = "Bearer #{access_token}"
      
      customer_details = session[:customer_details]
      
      request.body = {
        bank_code: customer_details[:bank_code],
        account_number: customer_details[:account_number],
        cnic_number: customer_details[:cnic_number],
        mobile_no: customer_details[:mobile_no]
      }.to_json
      
      response = http.request(request)
      
      if response.code == '200'
        JSON.parse(response.body)
      else
        Rails.logger.error "PayFast customer validation failed: #{response.code} - #{response.body}"
        nil
      end
    rescue => e
      Rails.logger.error "PayFast customer validation error: #{e.message}"
      nil
    end
  end
  
  def process_payment_with_otp(access_token, otp_code)
    begin
      uri = URI('https://gopayfast.com/transaction/process')
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      
      request = Net::HTTP::Post.new(uri)
      request['Content-Type'] = 'application/json'
      request['Accept'] = 'application/json'
      request['Authorization'] = "Bearer #{access_token}"
      
      customer_details = session[:customer_details]
      
      request.body = {
        amount: @booking.price.to_f,
        currency: 'PKR',
        order_id: "BOOKING_#{@booking.id}",
        description: "#{@booking.service.name} - Booking ##{@booking.id}",
        customer_name: @booking.client.name,
        customer_email: @booking.client.email,
        customer_mobile: customer_details[:mobile_no],
        bank_code: customer_details[:bank_code],
        account_number: customer_details[:account_number],
        cnic_number: customer_details[:cnic_number],
        otp_code: otp_code,
        return_url: payfast_return_url,
        cancel_url: payfast_cancel_url,
        notify_url: payfast_notify_url
      }.to_json
      
      response = http.request(request)
      
      if response.code == '200'
        JSON.parse(response.body)
      else
        Rails.logger.error "PayFast payment processing failed: #{response.code} - #{response.body}"
        nil
      end
    rescue => e
      Rails.logger.error "PayFast payment processing error: #{e.message}"
      nil
    end
  end
end