class SeedsController < ApplicationController
  def run
    # Simple secret key protection - change 'helpster2024seeds' to whatever you want
    return head :unauthorized unless Rails.env.development? || params[:secret] == 'helpster2024seeds'
    
    begin
      # Clear existing data in proper order (due to foreign key constraints)
      puts "Clearing existing data..."
      Booking.destroy_all
      Service.destroy_all
      
      # Clear all users (this includes ServiceProvider and Client due to STI)
      User.destroy_all
      
      # Alternative approach if above doesn't work:
      # ServiceProvider.destroy_all
      # Client.destroy_all
      # User.where(type: nil).destroy_all  # Clear any base User records

      # Service provider emails provided
      provider_emails = [
        'ranaubaid13579@gmail.com',
        'zain2579257911@gmail.com', 
        'mrjee2579257911@gmail.com',
        'mrzee2579257911@gmail.com',
        'selfcreator2579257911@gmail.com',
        'technicalwriter.mutawir.fcs@gmail.com',
        'zainn2579257911@gmail.com',
        'zainabtanveer601@gmail.com'
      ]

      # Additional emails for extra providers if needed
      additional_emails = [
        'provider1@example.com',
        'provider2@example.com',
        'provider3@example.com',
        'provider4@example.com'
      ]

      # Categories and their subcategories
      categories_data = {
        "Electrician" => [
          "Wiring Installation", "Lighting Fixtures", "Ceiling Fan Installation",
          "Circuit Breaker Repair", "Electrical Troubleshooting", "Switch & Socket Installation",
          "UPS/Inverter Installation", "Generator Connection", "Earthing System Setup",
          "Appliance Wiring", "Solar Panel Wiring"
        ],
        "Plumber" => [
          "Leak Fixing", "Pipe Installation", "Water Tank Cleaning",
          "Geyser Installation", "Bathroom Fittings", "Drain Cleaning",
          "Toilet Repair", "Kitchen Sink Fixing", "Water Motor Installation",
          "Seepage Detection", "Sewer Line Cleaning"
        ],
        "Mechanic" => [
          "Engine Repair", "Oil Change", "Tire Replacement",
          "Brake Service", "Battery Replacement", "AC Repair",
          "Suspension Repair", "Radiator Service", "Transmission Repair",
          "Clutch Replacement", "Car Tuning"
        ],
        "House Cleaner" => [
          "Carpet Cleaning", "Sofa Cleaning", "Kitchen Deep Cleaning",
          "Bathroom Deep Cleaning", "Window Cleaning", "Floor Scrubbing",
          "Wall Washing", "Dusting and Mopping", "Mattress Cleaning",
          "Refrigerator Cleaning", "Car Washing (at home)"
        ],
        "Carpenter" => [
          "Furniture Repair", "Custom Furniture", "Door Installation",
          "Cabinet Making", "Shelf Installation", "Wood Polishing",
          "Window Frame Repair", "Wardrobe Assembly", "Wood Flooring",
          "Partition Making", "False Ceiling Work"
        ],
        "Painter" => [
          "Interior Painting", "Exterior Painting", "Wall Texture Design",
          "Wood Polishing", "Metal Painting", "Waterproof Coating",
          "Wall Putty Work", "Spray Painting", "Ceiling Painting",
          "Paint Touchups", "Primer Application"
        ],
        "Gardener" => [
          "Lawn Mowing", "Weed Removal", "Planting Trees/Shrubs",
          "Hedge Trimming", "Garden Cleaning", "Soil Fertilizing",
          "Pest Control for Plants", "Watering System Installation",
          "Seasonal Flower Plantation", "Pruning and Shaping", "Composting"
        ]
      }

      # Cities for location variety
      cities = ["Lahore", "Karachi", "Islamabad", "Rawalpindi", "Faisalabad", "Multan", "Gujranwala", "Peshawar"]

      # Provider names for each category
      provider_names = {
        "Electrician" => ["ElectroFix Pro", "PowerLine Services", "Spark Masters", "Current Solutions"],
        "Plumber" => ["AquaFix Experts", "Pipe Masters", "FlowRight Services", "WaterWorks Pro"],
        "Mechanic" => ["AutoCare Plus", "Engine Masters", "CarFix Experts", "Motor Solutions"],
        "House Cleaner" => ["CleanPro Services", "Sparkle Clean", "Fresh Home Care", "Pure Clean Masters"],
        "Carpenter" => ["WoodCraft Pro", "Furniture Masters", "Timber Works", "Custom Wood Solutions"],
        "Painter" => ["ColorCraft Pro", "Paint Masters", "Brush & Roll", "Perfect Finish"],
        "Gardener" => ["GreenThumb Pro", "Garden Masters", "Nature Care", "Bloom & Grow"]
      }

      # Service names for each subcategory
      service_names = {
        "Wiring Installation" => ["Complete House Wiring", "Office Electrical Setup", "New Construction Wiring"],
        "Lighting Fixtures" => ["LED Light Installation", "Chandelier Mounting", "Track Lighting Setup"],
        "Ceiling Fan Installation" => ["Ceiling Fan with Light", "Industrial Fan Setup", "Decorative Fan Installation"],
        "Circuit Breaker Repair" => ["Main Panel Upgrade", "Breaker Replacement", "Circuit Protection Setup"],
        "Electrical Troubleshooting" => ["Power Outage Diagnosis", "Short Circuit Repair", "Electrical Safety Check"],
        "Switch & Socket Installation" => ["Smart Switch Setup", "USB Socket Installation", "Dimmer Switch Installation"],
        "UPS/Inverter Installation" => ["Home UPS Setup", "Solar Inverter Installation", "Battery Backup System"],
        "Generator Connection" => ["Standby Generator Setup", "Portable Generator Connection", "Auto Transfer Switch"],
        "Earthing System Setup" => ["House Earthing Installation", "Electrical Grounding System", "Lightning Protection"],
        "Appliance Wiring" => ["AC Unit Wiring", "Water Heater Connection", "Kitchen Appliance Setup"],
        "Solar Panel Wiring" => ["Rooftop Solar Installation", "Grid-Tie System Setup", "Off-Grid Solar System"],
        "Leak Fixing" => ["Pipe Leak Repair", "Faucet Leak Fix", "Underground Leak Detection"],
        "Pipe Installation" => ["New Water Line Installation", "Gas Pipe Setup", "Drainage System Installation"],
        "Water Tank Cleaning" => ["Overhead Tank Cleaning", "Underground Tank Sanitization", "Water Storage Maintenance"],
        "Geyser Installation" => ["Electric Geyser Setup", "Gas Geyser Installation", "Solar Water Heater Setup"],
        "Bathroom Fittings" => ["Complete Bathroom Setup", "Shower Installation", "Toilet Fixture Installation"],
        "Drain Cleaning" => ["Blocked Drain Cleaning", "Sewer Line Unclogging", "Kitchen Drain Maintenance"],
        "Toilet Repair" => ["Toilet Bowl Replacement", "Flush System Repair", "Toilet Seat Installation"],
        "Kitchen Sink Fixing" => ["Kitchen Sink Installation", "Garbage Disposal Setup", "Faucet Replacement"],
        "Water Motor Installation" => ["Submersible Pump Setup", "Pressure Pump Installation", "Water Pump Repair"],
        "Seepage Detection" => ["Wall Seepage Repair", "Roof Leak Detection", "Foundation Waterproofing"],
        "Sewer Line Cleaning" => ["Main Sewer Cleaning", "Septic Tank Cleaning", "Drainage Maintenance"],
        "Engine Repair" => ["Engine Overhaul", "Engine Tune-up", "Engine Diagnostic Service"],
        "Oil Change" => ["Regular Oil Change", "Synthetic Oil Service", "Oil Filter Replacement"],
        "Tire Replacement" => ["New Tire Installation", "Tire Rotation Service", "Wheel Balancing"],
        "Brake Service" => ["Brake Pad Replacement", "Brake Fluid Change", "Brake System Inspection"],
        "Battery Replacement" => ["Car Battery Installation", "Battery Testing Service", "Alternator Check"],
        "AC Repair" => ["Car AC Service", "AC Gas Refill", "AC Compressor Repair"],
        "Suspension Repair" => ["Shock Absorber Replacement", "Strut Repair", "Suspension Alignment"],
        "Radiator Service" => ["Radiator Flush", "Cooling System Repair", "Thermostat Replacement"],
        "Transmission Repair" => ["Automatic Transmission Service", "Manual Gearbox Repair", "Clutch Adjustment"],
        "Clutch Replacement" => ["Clutch Plate Replacement", "Clutch Cable Adjustment", "Flywheel Resurfacing"],
        "Car Tuning" => ["Engine Performance Tuning", "ECU Remapping", "Exhaust System Upgrade"],
        "Carpet Cleaning" => ["Deep Carpet Cleaning", "Carpet Stain Removal", "Carpet Shampooing"],
        "Sofa Cleaning" => ["Fabric Sofa Cleaning", "Leather Sofa Care", "Upholstery Deep Clean"],
        "Kitchen Deep Cleaning" => ["Complete Kitchen Sanitization", "Appliance Deep Clean", "Grease Removal Service"],
        "Bathroom Deep Cleaning" => ["Bathroom Sanitization", "Tile and Grout Cleaning", "Mold Removal Service"],
        "Window Cleaning" => ["Interior Window Cleaning", "Exterior Window Wash", "Window Frame Cleaning"],
        "Floor Scrubbing" => ["Tile Floor Deep Clean", "Hardwood Floor Care", "Marble Floor Polishing"],
        "Wall Washing" => ["Wall Deep Cleaning", "Paint Stain Removal", "Wallpaper Cleaning"],
        "Dusting and Mopping" => ["Regular House Cleaning", "Weekly Maintenance Clean", "Post-Construction Cleanup"],
        "Mattress Cleaning" => ["Mattress Deep Sanitization", "Bed Bug Treatment", "Stain Removal Service"],
        "Refrigerator Cleaning" => ["Fridge Deep Clean", "Appliance Sanitization", "Kitchen Equipment Clean"],
        "Car Washing (at home)" => ["Mobile Car Wash", "Car Interior Cleaning", "Vehicle Detailing Service"],
        "Furniture Repair" => ["Chair Repair Service", "Table Restoration", "Cabinet Door Fix"],
        "Custom Furniture" => ["Custom Dining Table", "Bespoke Wardrobe", "Handcrafted Bookshelf"],
        "Door Installation" => ["Interior Door Setup", "Security Door Installation", "Sliding Door Setup"],
        "Cabinet Making" => ["Kitchen Cabinet Installation", "Bathroom Vanity Setup", "Storage Cabinet Build"],
        "Shelf Installation" => ["Wall Shelf Mounting", "Floating Shelf Setup", "Corner Shelf Installation"],
        "Wood Polishing" => ["Furniture Polish Service", "Wood Restoration", "Antique Furniture Care"],
        "Window Frame Repair" => ["Wooden Window Repair", "Frame Replacement", "Window Sill Repair"],
        "Wardrobe Assembly" => ["Built-in Wardrobe", "Modular Closet Setup", "Walk-in Closet Build"],
        "Wood Flooring" => ["Hardwood Floor Installation", "Laminate Flooring", "Parquet Floor Setup"],
        "Partition Making" => ["Room Divider Installation", "Office Partition Setup", "Decorative Screen Build"],
        "False Ceiling Work" => ["Gypsum Ceiling Installation", "POP Ceiling Work", "Suspended Ceiling Setup"],
        "Interior Painting" => ["Room Painting Service", "Wall Color Change", "Interior Design Painting"],
        "Exterior Painting" => ["House Exterior Paint", "Building Facade Painting", "Weather Protection Paint"],
        "Wall Texture Design" => ["Textured Wall Finish", "Decorative Wall Art", "Designer Wall Treatment"],
        "Metal Painting" => ["Gate Painting Service", "Metal Fence Paint", "Rust Prevention Coating"],
        "Waterproof Coating" => ["Roof Waterproofing", "Basement Sealing", "Exterior Wall Protection"],
        "Wall Putty Work" => ["Wall Preparation Service", "Surface Smoothing", "Crack Filling"],
        "Spray Painting" => ["Professional Spray Paint", "Even Coating Service", "Quick Paint Job"],
        "Ceiling Painting" => ["Ceiling Color Change", "Ceiling Repair Paint", "High Ceiling Service"],
        "Paint Touchups" => ["Minor Paint Repair", "Spot Painting", "Color Matching Service"],
        "Primer Application" => ["Wall Primer Service", "Surface Preparation", "Paint Base Coating"],
        "Lawn Mowing" => ["Regular Grass Cutting", "Lawn Maintenance", "Garden Grass Care"],
        "Weed Removal" => ["Garden Weed Control", "Lawn Weed Removal", "Plant Bed Weeding"],
        "Planting Trees/Shrubs" => ["Tree Plantation", "Decorative Plant Setup", "Garden Landscaping"],
        "Hedge Trimming" => ["Hedge Cutting Service", "Topiary Shaping", "Bush Trimming"],
        "Garden Cleaning" => ["Complete Garden Cleanup", "Yard Maintenance", "Garden Waste Removal"],
        "Soil Fertilizing" => ["Lawn Fertilization", "Plant Nutrition", "Soil Treatment"],
        "Pest Control for Plants" => ["Garden Pest Management", "Plant Disease Treatment", "Organic Pest Control"],
        "Watering System Installation" => ["Drip Irrigation Setup", "Sprinkler System", "Garden Watering Solution"],
        "Seasonal Flower Plantation" => ["Flower Garden Setup", "Seasonal Plant Care", "Colorful Garden Design"],
        "Pruning and Shaping" => ["Tree Pruning Service", "Plant Shaping", "Garden Maintenance"],
        "Composting" => ["Organic Compost Setup", "Garden Waste Composting", "Natural Fertilizer Preparation"]
      }

      # Create service providers and services
      puts "Creating service providers and services..."

      email_index = 0
      all_emails = provider_emails + additional_emails

      categories_data.each do |category, subcategories|
        # Create 3 providers per category
        3.times do |i|
          # Use provided emails first, then additional ones
          email = all_emails[email_index % all_emails.length]
          email_index += 1
          
          # Create service provider with unique timestamp to avoid conflicts
          provider = ServiceProvider.create!(
            email: email,
            password: 'password123',
            password_confirmation: 'password123',
            full_name: "#{provider_names[category][i]} Owner",
            phone_number: "0300#{rand(1000000..9999999)}",
            category: category,
            subcategories: subcategories.sample(rand(4..6)), # Each provider handles 4-6 subcategories
            experience_years: rand(2..15),
            short_info: "Professional #{category.downcase} with #{rand(2..15)} years of experience. Quality work guaranteed."
          )
          
          puts "Created #{category} provider: #{provider.full_name} (#{provider.email})"
          
          # Create 2 services for each subcategory this provider handles
          provider.subcategories.each do |subcategory|
            2.times do |j|
              # Get service names for this subcategory
              available_names = service_names[subcategory] || ["#{subcategory} Service", "Professional #{subcategory}"]
              service_name = available_names[j % available_names.length]
              
              # Set price based on category
              price = case category
                      when "Electrician" then rand(800..3000)
                      when "Plumber" then rand(600..2500)
                      when "Mechanic" then rand(1000..5000)
                      when "House Cleaner" then rand(500..2000)
                      when "Carpenter" then rand(800..4000)
                      when "Painter" then rand(600..3000)
                      when "Gardener" then rand(400..1500)
                      else rand(500..2000)
                      end
              
              Service.create!(
                name: service_name,
                description: "#{service_name} - Professional #{category.downcase} service with experienced technicians. Contact us for quality #{subcategory.downcase} services.",
                category: category,
                subcategory: subcategory,
                price: price,
                location: cities.sample,
                provider_id: provider.id
              )
            end
          end
        end
      end

      # Create some sample clients
      puts "Creating sample clients..."
      5.times do |i|
        Client.create!(
          email: "client#{i+1}@example.com",
          password: 'password123',
          password_confirmation: 'password123',
          full_name: "Client User #{i+1}",
          phone_number: "0301#{rand(1000000..9999999)}"
        )
      end

      render json: {
        status: 'success',
        message: 'Seed data created successfully!',
        data: {
          service_providers: ServiceProvider.count,
          services: Service.count,
          clients: Client.count
        }
      }

    rescue => e
      render json: {
        status: 'error',
        message: e.message,
        backtrace: e.backtrace.first(10)
      }, status: 500
    end
  end
end