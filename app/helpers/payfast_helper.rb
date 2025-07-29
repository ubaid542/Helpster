module PayfastHelper
  def payfast_payment_url(booking)
    # JazzCash credentials - Update these environment variables
    merchant_id = ENV['JAZZCASH_MERCHANT_ID'] || 'TestMerchant' # Default for testing
    secured_key = ENV['JAZZCASH_SECURED_KEY'] || 'TestSecuredKey' # Default for testing
    
    # Payment data for JazzCash
    data = {
      pp_Version: '1.1',
      pp_TxnType: 'MWALLET', # Mobile Wallet payment
      pp_Language: 'EN',
      pp_MerchantID: merchant_id,
      pp_SubMerchantID: '', # Optional
      pp_Password: secured_key,
      pp_BankID: 'TBANK',
      pp_ProductID: 'RETL',
      pp_TxnRefNo: "T#{Time.current.strftime('%Y%m%d%H%M%S')}#{booking.id}",
      pp_Amount: (booking.price.to_f * 100).to_i, # Amount in paisas
      pp_TxnCurrency: 'PKR',
      pp_TxnDateTime: Time.current.strftime('%Y%m%d%H%M%S'),
      pp_BillReference: "BOOKING_#{booking.id}",
      pp_Description: "#{booking.service.name} on #{booking.date}",
      pp_TxnExpiryDateTime: 1.hour.from_now.strftime('%Y%m%d%H%M%S'),
      pp_ReturnURL: "#{request.base_url}/payfast/return",
      pp_SecureHash: '',
      ppmpf_1: booking.client.full_name || 'Customer',
      ppmpf_2: booking.client.email,
      ppmpf_3: booking.client.phone_number || '03001234567',
      ppmpf_4: '',
      ppmpf_5: ''
    }
    
    # Generate secure hash for JazzCash
    # Remove pp_SecureHash from data for hash calculation
    hash_data = data.except(:pp_SecureHash)
    sorted_string = hash_data.sort.map { |k, v| "#{k}=#{v}" }.join('&')
    
    # Add the secured key at the end
    hash_string = "#{sorted_string}&#{secured_key}"
    secure_hash = Digest::SHA256.hexdigest(hash_string)
    data[:pp_SecureHash] = secure_hash
    
    # Return JazzCash sandbox URL
    "https://sandbox.jazzcash.com.pk/ApplicationAPI/API/Payment/DoTransaction?#{data.to_query}"
  end
end