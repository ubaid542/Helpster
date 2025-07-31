# Stripe Configuration
if Rails.env.development? || Rails.env.production?
  Stripe.api_key = ENV['STRIPE_SECRET_KEY']
end

# Log Stripe version for debugging
Rails.logger.info "Stripe initialized with version: #{Stripe::VERSION}" if defined?(Stripe::VERSION)