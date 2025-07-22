# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end



Service.create!([
  {
    name: "Professional House Cleaning",
    description: "Complete house cleaning service including all rooms, bathrooms, and kitchen. We use eco-friendly products.",
    category: "home-cleaning",
    price: 120.00,
    location: "Lahore",
    provider_name: "Clean Pro Services",
    provider_email: "info@cleanpro.com",
    provider_phone: "+92-300-1234567"
  },
  {
    name: "Furniture Assembly",
    description: "Expert furniture assembly for IKEA and other brands. Tools and experience included.",
    category: "handyman",
    price: 80.00,
    location: "Karachi",
    provider_name: "Fix It Fast",
    provider_email: "contact@fixitfast.com",
    provider_phone: "+92-321-9876543"
  }
])