module PayfastHelper
  def payfast_payment_url(booking)
    # PayFast credentials
    merchant_id = ENV['PAYFAST_MERCHANT_ID']
    secured_key = ENV['PAYFAST_SECURED_KEY']
    
    # Payment data
    data = {
      merchant_id: merchant_id,
      secured_key: secured_key,
      return_url: "#{request.base_url}/payfast/return",
      cancel_url: "#{request.base_url}/payfast/cancel",
      callback_url: "#{request.base_url}/payfast/notify",
      customer_name: booking.client.full_name || 'Customer',
      customer_email: booking.client.email,
      customer_phone: booking.client.phone_number || '03001234567',
      order_id: "BOOKING_#{booking.id}",
      amount: booking.price.to_i,
      currency: 'PKR',
      product_name: "Service Booking ##{booking.id}",
      product_description: "#{booking.service.name} on #{booking.date}",
      test_mode: '1'
    }
    
    # Generate signature
    param_string = data.sort.map { |k, v| "#{k}=#{v}" }.join('&')
    signature = Digest::MD5.hexdigest(param_string)
    data[:signature] = signature
    
    # Return PayFast URL
    "https://sandbox.gopayfast.com/payment/process?#{data.to_query}"
  end
end