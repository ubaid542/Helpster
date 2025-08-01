class StripeController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:webhook]
  before_action :authenticate_user!, except: [:webhook, :success, :cancel]

  def payment
    @booking = Booking.find(params[:booking_id])
    
    # Check if user owns this booking
    unless @booking.client_id == current_user.id
      redirect_to client_dashboard_path, alert: "Access denied."
      return
    end

    # Check if booking requires payment
    unless @booking.status == 'completed' && @booking.requires_payment?
      redirect_to client_dashboard_path, alert: "This booking doesn't require payment."
      return
    end
  end

  def create_checkout_session
    @booking = Booking.find(params[:booking_id])

    Rails.logger.info "Booking price: #{@booking.price}"
    Rails.logger.info "Calculated amount: #{(@booking.price * 100).to_i}"
    
    # Validate the booking
    unless @booking.client_id == current_user.id && @booking.requires_payment?
      redirect_to client_dashboard_path, alert: "Invalid payment request."
      return
    end

    begin
      # Initialize Stripe
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      
      # Get client information
      client = User.find(@booking.client_id)
      
      # Base URL for your site
      base_url = request.base_url
      
      # Create Stripe Checkout Session
      session = Stripe::Checkout::Session.create({
        payment_method_types: ['card'],
        line_items: [{
          price_data: {
            currency: 'pkr',  # Stripe works better with USD for international
            product_data: {
              name: "Service Booking ##{@booking.id}",
              description: "#{@booking.service.name} on #{@booking.date}",
            },
            unit_amount: (@booking.price * 100).to_i,  # Stripe uses cents
          },
          quantity: 1,
        }],
        mode: 'payment',
        success_url: "#{base_url}/stripe/success?session_id={CHECKOUT_SESSION_ID}",
        cancel_url: "#{base_url}/stripe/cancel?booking_id=#{@booking.id}",
        metadata: {
          booking_id: @booking.id,
          customer_email: client.email,
          customer_name: client.full_name || 'Customer'
        },
        customer_email: client.email,
        automatic_tax: {
          enabled: false
        }
      })

      # Update booking with Stripe session info
      @booking.update!(
        payment_status: 'pending',
        payment_reference: session.id,
      )

      # Redirect to Stripe's hosted checkout page
      redirect_to session.url, allow_other_host: true
      
    rescue Stripe::StripeError => e
      Rails.logger.error "Stripe error: #{e.message}"
      redirect_to client_dashboard_path, alert: "Payment processing error: #{e.message}"
    rescue => e
      Rails.logger.error "Payment error: #{e.message}"
      redirect_to client_dashboard_path, alert: "An error occurred. Please try again."
    end
  end

  def success
    session_id = params[:session_id]
    
    unless session_id
      redirect_to client_dashboard_path, alert: "Invalid payment session."
      return
    end
    
    begin
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      session = Stripe::Checkout::Session.retrieve(session_id)
      
      if session.payment_status == 'paid'
        booking_id = session.metadata['booking_id']
        booking = Booking.find_by(id: booking_id)
        
        if booking && booking.payment_pending?
          booking.update!(
            payment_status: 'paid',
            payment_reference: session.payment_intent,
            payment_provider: 'stripe',
            paid_at: Time.current
          )
          flash[:success] = "Payment completed successfully! Transaction ID: #{session.payment_intent}"
        else
          flash[:alert] = 'Booking not found or already paid.'
        end
      else
        flash[:alert] = 'Payment verification failed.'
      end
    rescue Stripe::StripeError => e
      Rails.logger.error "Stripe success verification error: #{e.message}"
      flash[:alert] = 'Payment verification failed.'
    rescue => e
      Rails.logger.error "Success page error: #{e.message}"
      flash[:alert] = 'An error occurred during payment verification.'
    end
    
    redirect_to client_dashboard_path
  end

  def cancel
    booking_id = params[:booking_id]
    
    if booking_id
      booking = Booking.find_by(id: booking_id)
      booking&.update(payment_status: 'cancelled') if booking&.payment_pending?
    end
    
    flash[:alert] = 'Payment was cancelled. You can try again anytime.'
    redirect_to client_dashboard_path
  end

  def webhook
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = ENV['STRIPE_WEBHOOK_SECRET']

    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
      
      case event['type']
      when 'checkout.session.completed'
        session = event['data']['object']
        handle_successful_payment(session)
      when 'payment_intent.succeeded'
        payment_intent = event['data']['object']
        Rails.logger.info "Payment Intent succeeded: #{payment_intent['id']}"
      else
        Rails.logger.info "Unhandled event type: #{event['type']}"
      end

      render json: { status: 'success' }
    rescue JSON::ParserError => e
      Rails.logger.error "Invalid payload: #{e.message}"
      render json: { error: 'Invalid payload' }, status: 400
    rescue Stripe::SignatureVerificationError => e
      Rails.logger.error "Invalid signature: #{e.message}"
      render json: { error: 'Invalid signature' }, status: 400
    rescue => e
      Rails.logger.error "Webhook error: #{e.message}"
      render json: { error: 'Webhook error' }, status: 400
    end
  end

  def test_env
  render json: {
    stripe_secret_present: ENV['STRIPE_SECRET_KEY'].present?,
    stripe_secret_prefix: ENV['STRIPE_SECRET_KEY']&.first(15),
    stripe_publishable_present: ENV['STRIPE_PUBLISHABLE_KEY'].present?,
    stripe_publishable_prefix: ENV['STRIPE_PUBLISHABLE_KEY']&.first(15)
  }
end

  private

  def handle_successful_payment(session)
    booking_id = session['metadata']['booking_id']
    booking = Booking.find_by(id: booking_id)
    
    if booking && booking.payment_pending?
      booking.update!(
        payment_status: 'paid',
        payment_reference: session['payment_intent'],
        payment_provider: 'stripe',
        paid_at: Time.current
      )
      Rails.logger.info "Stripe payment completed for booking #{booking.id}, Session: #{session['id']}"
    end
  end
end