class PayfastController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:notify]
  before_action :authenticate_user!, except: [:notify, :return, :cancel]

  def payment
    @booking = Booking.find(params[:booking_id])
    
    # Check if user owns this booking (client_id references users table)
    unless @booking.client_id == current_user.id
      redirect_to client_dashboard_path, alert: "Access denied."
      return
    end

    # Check if booking is completed and requires payment
    unless @booking.status == 'completed' && @booking.requires_payment?
      redirect_to client_dashboard_path, alert: "This booking doesn't require payment."
      return
    end
  end

  def process_payment
    @booking = Booking.find(params[:booking_id])
    
    # Validate the booking (client_id references users table)
    unless @booking.client_id == current_user.id && @booking.requires_payment?
      redirect_to client_dashboard_path, alert: "Invalid payment request."
      return
    end

    # PayFast Pakistan credentials
    merchant_id = ENV['PAYFAST_MERCHANT_ID'] || '110515'
    secured_key = ENV['PAYFAST_SECURED_KEY'] || 'k0S7IvCjSrX3NCkrYJCei0ac'
    
    # Base URL for your production site
    base_url = 'https://helpster-d45g.onrender.com'
    
    # Get client information (booking.client is a User with type Client)
    client = User.find(@booking.client_id)
    
    # Payment data for PayFast Pakistan
    payment_data = {
      'merchant_id' => merchant_id,
      'secured_key' => secured_key,
      'return_url' => "#{base_url}/payfast/return",
      'cancel_url' => "#{base_url}/payfast/cancel",
      'callback_url' => "#{base_url}/payfast/notify",
      'customer_name' => client.full_name || 'Customer',
      'customer_email' => client.email,
      'customer_phone' => client.phone_number || '03001234567',
      'order_id' => "BOOKING_#{@booking.id}",
      'amount' => @booking.price.to_i,
      'currency' => 'PKR',
      'product_name' => "Service Booking ##{@booking.id}",
      'product_description' => "#{@booking.service.name} on #{@booking.date}",
      'test_mode' => '1'  # Set to '0' for live payments
    }

    # Generate signature for PayFast Pakistan
    param_string = payment_data.sort.map { |k, v| "#{k}=#{v}" }.join('&')
    payment_data['signature'] = Digest::MD5.hexdigest(param_string)

    # PayFast Pakistan sandbox URL
    payfast_url = 'https://sandbox.payfast.co.za/'
    
    # Create form HTML for auto-submission
    @form_html = generate_payment_form(payment_data, payfast_url)
    
    render :redirect_to_payfast
  end

  def return
    order_id = params[:order_id]
    status = params[:status]
    transaction_id = params[:transaction_id]
    
    Rails.logger.info "PayFast Pakistan return: #{params.inspect}"
    
    if status == 'success' || status == 'completed'
      if order_id && order_id.start_with?('BOOKING_')
        booking_id = order_id.gsub('BOOKING_', '')
        booking = Booking.find_by(id: booking_id)
        
        if booking
          booking.update!(
            payment_status: 'paid',
            payment_reference: transaction_id,
            paid_at: Time.current
          )
          flash[:success] = "Payment completed successfully! Transaction ID: #{transaction_id}"
        else
          flash[:alert] = 'Booking not found.'
        end
      else
        flash[:alert] = 'Invalid payment response.'
      end
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
    Rails.logger.info "PayFast Pakistan notification received: #{params.inspect}"
    
    # Validate the signature
    received_signature = params[:signature]
    validation_params = params.except(:signature, :controller, :action)
    
    # Create signature string for PayFast Pakistan
    param_string = validation_params.sort.map { |k, v| "#{k}=#{v}" }.join('&')
    expected_signature = Digest::MD5.hexdigest(param_string)
    
    if received_signature == expected_signature
      if params[:status] == 'completed' || params[:status] == 'success'
        order_id = params[:order_id]
        
        if order_id && order_id.start_with?('BOOKING_')
          booking_id = order_id.gsub('BOOKING_', '')
          booking = Booking.find_by(id: booking_id)
          
          if booking && booking.payment_pending?
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
      Rails.logger.error "Invalid signature in PayFast Pakistan notification"
      render plain: 'Invalid signature', status: 400
    end
  rescue => e
    Rails.logger.error "PayFast Pakistan notification error: #{e.message}"
    render plain: 'Error', status: 500
  end

  private

  def generate_payment_form(payment_data, action_url)
    form_fields = payment_data.map do |key, value|
      "<input type='hidden' name='#{key}' value='#{CGI.escapeHTML(value.to_s)}' />"
    end.join("\n")

    <<~HTML
      <form id="payfast_form" action="#{action_url}" method="post">
        #{form_fields}
      </form>
      <script type="text/javascript">
        document.getElementById('payfast_form').submit();
      </script>
    HTML
  end
end