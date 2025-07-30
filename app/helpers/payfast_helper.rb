module PayfastHelper
  def payfast_payment_url(booking)
    payfast_payment_path(booking_id: booking.id)
  end

  def generate_payfast_signature(data)
    # Remove signature if present
    data_without_signature = data.except('signature')
    
    # Create parameter string for PayFast Pakistan
    param_string = data_without_signature.sort.map { |key, val| "#{key}=#{val}" }.join('&')
    
    # Generate MD5 hash
    Digest::MD5.hexdigest(param_string)
  end

  def payfast_pakistan_credentials
    {
      merchant_id: '110515',
      secured_key: 'k0S7IvCjSrX3NCkrYJCei0ac',
      sandbox_url: 'https://sandbox.gopayfast.com/payment/process',
      live_url: 'https://gopayfast.com/payment/process'
    }
  end

  def payfast_pakistan_test_details
    {
      bank_name: 'Demo Bank',
      account_number: '12353940226802034243',
      cnic: '4210131315089',
      otp: '123456'
    }
  end
end