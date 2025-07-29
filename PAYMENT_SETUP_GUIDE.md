# JazzCash Payment Gateway Setup Guide

## Issue Resolution

Your payment integration was failing because:
1. **Invalid Payment Gateway**: You were using `https://sandbox.gopayfast.com/payment/process` which doesn't exist
2. **Missing Credentials**: Environment variables `PAYFAST_MERCHANT_ID` and `PAYFAST_SECURED_KEY` were not set
3. **Incorrect API Format**: The payment data structure didn't match any real payment gateway

## Solution: JazzCash Integration

I've updated your code to use **JazzCash**, a legitimate Pakistani payment gateway.

### 1. Environment Setup

Create a `.env` file in your project root:

```bash
# JazzCash Payment Gateway Configuration
JAZZCASH_MERCHANT_ID=your_merchant_id_here
JAZZCASH_SECURED_KEY=your_secured_key_here

# Database Configuration  
HELPSTER_DATABASE_PASSWORD=your_database_password

# Email Configuration
GMAIL_USERNAME=your_email@gmail.com
GMAIL_PASSWORD=your_app_password
```

### 2. Install Dependencies

```bash
bundle install
```

### 3. Get JazzCash Credentials

1. Visit [JazzCash Sandbox](https://sandbox.jazzcash.com.pk/)
2. Sign up for a merchant account
3. Complete the verification process
4. Get your `Merchant ID` and `Secured Key` from the merchant portal
5. Update your `.env` file with these credentials

### 4. Testing Credentials (For Development)

For initial testing, you can use these test credentials:
- `JAZZCASH_MERCHANT_ID=TestMerchant`
- `JAZZCASH_SECURED_KEY=TestSecuredKey`

### 5. Code Changes Made

#### Updated Files:
- `app/helpers/payfast_helper.rb` - Now generates JazzCash-compatible payment URLs
- `app/controllers/payfast_controller.rb` - Handles JazzCash response parameters
- `Gemfile` - Added dotenv-rails for environment variable management
- `config/routes.rb` - Updated route comments

#### Key Changes:
- Payment URL now points to JazzCash sandbox: `https://sandbox.jazzcash.com.pk/ApplicationAPI/API/Payment/DoTransaction`
- Uses JazzCash parameter format (pp_* parameters)
- Implements SHA256 hash validation instead of MD5
- Handles JazzCash response codes ('000' for success)

### 6. Testing the Integration

1. Set up your environment variables
2. Start your Rails server: `rails server`
3. Navigate to the client dashboard
4. Click the "Pay" button on a completed booking
5. You should now be redirected to JazzCash payment page

### 7. Production Setup

For production:
1. Get production credentials from JazzCash
2. Update the payment URL to production endpoint
3. Set production environment variables
4. Test thoroughly before going live

### 8. Alternative Payment Gateways

If JazzCash doesn't work for you, consider these Pakistani payment gateways:
- **1Link**: sandbox.1link.net.pk
- **MyPay**: mypay.pk
- **FrontPay**: frontpay.pk

### 9. Troubleshooting

- **"Site can't be reached"**: Check your internet connection and gateway URL
- **"Invalid hash"**: Verify your secured key and hash generation logic
- **"Transaction failed"**: Check merchant credentials and transaction parameters

### 10. Support

- JazzCash Documentation: [sandbox.jazzcash.com.pk/SandboxDocumentation](https://sandbox.jazzcash.com.pk/SandboxDocumentation/index.html)
- JazzCash Support: Contact through their merchant portal

## Next Steps

1. Create `.env` file with your credentials
2. Run `bundle install`
3. Test the payment flow
4. Apply for production credentials when ready