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

      # Categories and their subcategories (in parameterized format)
      categories_data = {
        "electrician" => [
          "wiring-installation", "lighting-fixtures", "ceiling-fan-installation",
          "circuit-breaker-repair", "electrical-troubleshooting", "switch-socket-installation",
          "ups-inverter-installation", "generator-connection", "earthing-system-setup",
          "appliance-wiring", "solar-panel-wiring"
        ],
        "plumber" => [
          "leak-fixing", "pipe-installation", "water-tank-cleaning",
          "geyser-installation", "bathroom-fittings", "drain-cleaning",
          "toilet-repair", "kitchen-sink-fixing", "water-motor-installation",
          "seepage-detection", "sewer-line-cleaning"
        ],
        "mechanic" => [
          "engine-repair", "oil-change", "tire-replacement",
          "brake-service", "battery-replacement", "ac-repair",
          "suspension-repair", "radiator-service", "transmission-repair",
          "clutch-replacement", "car-tuning"
        ],
        "house-cleaner" => [
          "carpet-cleaning", "sofa-cleaning", "kitchen-deep-cleaning",
          "bathroom-deep-cleaning", "window-cleaning", "floor-scrubbing",
          "wall-washing", "dusting-and-mopping", "mattress-cleaning",
          "refrigerator-cleaning", "car-washing-at-home"
        ],
        "carpenter" => [
          "furniture-repair", "custom-furniture", "door-installation",
          "cabinet-making", "shelf-installation", "wood-polishing",
          "window-frame-repair", "wardrobe-assembly", "wood-flooring",
          "partition-making", "false-ceiling-work"
        ],
        "painter" => [
          "interior-painting", "exterior-painting", "wall-texture-design",
          "wood-polishing", "metal-painting", "waterproof-coating",
          "wall-putty-work", "spray-painting", "ceiling-painting",
          "paint-touchups", "primer-application"
        ],
        "gardener" => [
          "lawn-mowing", "weed-removal", "planting-trees-shrubs",
          "hedge-trimming", "garden-cleaning", "soil-fertilizing",
          "pest-control-for-plants", "watering-system-installation",
          "seasonal-flower-plantation", "pruning-and-shaping", "composting"
        ]
      }

      # Cities with provinces for Pakistan
      locations = [
        { city: "Lahore", province: "Punjab", country: "Pakistan" },
        { city: "Karachi", province: "Sindh", country: "Pakistan" },
        { city: "Islamabad", province: "Islamabad Capital Territory", country: "Pakistan" },
        { city: "Rawalpindi", province: "Punjab", country: "Pakistan" },
        { city: "Faisalabad", province: "Punjab", country: "Pakistan" },
        { city: "Multan", province: "Punjab", country: "Pakistan" },
        { city: "Gujranwala", province: "Punjab", country: "Pakistan" },
        { city: "Peshawar", province: "Khyber Pakhtunkhwa", country: "Pakistan" },
        { city: "Quetta", province: "Balochistan", country: "Pakistan" },
        { city: "Sialkot", province: "Punjab", country: "Pakistan" },
        { city: "Hyderabad", province: "Sindh", country: "Pakistan" },
        { city: "Bahawalpur", province: "Punjab", country: "Pakistan" }
      ]

      # Sample addresses for different cities
      sample_addresses = [
        "Block A, Gulberg Town",
        "Phase 2, DHA",
        "Sector 15, Gulshan-e-Iqbal",
        "Model Town Extension",
        "Johar Town, Block J",
        "Cavalry Ground",
        "Garden Town",
        "Cantt Area",
        "Civil Lines",
        "Satellite Town",
        "New City Phase 1",
        "Commercial Area"
      ]

      # Provider names for each category (using proper casing for display)
      provider_names = {
        "electrician" => ["ElectroFix Pro", "PowerLine Services", "Spark Masters", "Current Solutions"],
        "plumber" => ["AquaFix Experts", "Pipe Masters", "FlowRight Services", "WaterWorks Pro"],
        "mechanic" => ["AutoCare Plus", "Engine Masters", "CarFix Experts", "Motor Solutions"],
        "house-cleaner" => ["CleanPro Services", "Sparkle Clean", "Fresh Home Care", "Pure Clean Masters"],
        "carpenter" => ["WoodCraft Pro", "Furniture Masters", "Timber Works", "Custom Wood Solutions"],
        "painter" => ["ColorCraft Pro", "Paint Masters", "Brush & Roll", "Perfect Finish"],
        "gardener" => ["GreenThumb Pro", "Garden Masters", "Nature Care", "Bloom & Grow"]
      }

      # Service names for each subcategory
      service_names = {
        "wiring-installation" => ["Complete House Wiring", "Office Electrical Setup", "New Construction Wiring"],
        "lighting-fixtures" => ["LED Light Installation", "Chandelier Mounting", "Track Lighting Setup"],
        "ceiling-fan-installation" => ["Ceiling Fan with Light", "Industrial Fan Setup", "Decorative Fan Installation"],
        "circuit-breaker-repair" => ["Main Panel Upgrade", "Breaker Replacement", "Circuit Protection Setup"],
        "electrical-troubleshooting" => ["Power Outage Diagnosis", "Short Circuit Repair", "Electrical Safety Check"],
        "switch-socket-installation" => ["Smart Switch Setup", "USB Socket Installation", "Dimmer Switch Installation"],
        "ups-inverter-installation" => ["Home UPS Setup", "Solar Inverter Installation", "Battery Backup System"],
        "generator-connection" => ["Standby Generator Setup", "Portable Generator Connection", "Auto Transfer Switch"],
        "earthing-system-setup" => ["House Earthing Installation", "Electrical Grounding System", "Lightning Protection"],
        "appliance-wiring" => ["AC Unit Wiring", "Water Heater Connection", "Kitchen Appliance Setup"],
        "solar-panel-wiring" => ["Rooftop Solar Installation", "Grid-Tie System Setup", "Off-Grid Solar System"],
        
        "leak-fixing" => ["Pipe Leak Repair", "Faucet Leak Fix", "Underground Leak Detection"],
        "pipe-installation" => ["New Water Line Installation", "Gas Pipe Setup", "Drainage System Installation"],
        "water-tank-cleaning" => ["Overhead Tank Cleaning", "Underground Tank Sanitization", "Water Storage Maintenance"],
        "geyser-installation" => ["Electric Geyser Setup", "Gas Geyser Installation", "Solar Water Heater Setup"],
        "bathroom-fittings" => ["Complete Bathroom Setup", "Shower Installation", "Toilet Fixture Installation"],
        "drain-cleaning" => ["Blocked Drain Cleaning", "Sewer Line Unclogging", "Kitchen Drain Maintenance"],
        "toilet-repair" => ["Toilet Bowl Replacement", "Flush System Repair", "Toilet Seat Installation"],
        "kitchen-sink-fixing" => ["Kitchen Sink Installation", "Garbage Disposal Setup", "Faucet Replacement"],
        "water-motor-installation" => ["Submersible Pump Setup", "Pressure Pump Installation", "Water Pump Repair"],
        "seepage-detection" => ["Wall Seepage Repair", "Roof Leak Detection", "Foundation Waterproofing"],
        "sewer-line-cleaning" => ["Main Sewer Cleaning", "Septic Tank Cleaning", "Drainage Maintenance"],
        
        "engine-repair" => ["Engine Overhaul", "Engine Tune-up", "Engine Diagnostic Service"],
        "oil-change" => ["Regular Oil Change", "Synthetic Oil Service", "Oil Filter Replacement"],
        "tire-replacement" => ["New Tire Installation", "Tire Rotation Service", "Wheel Balancing"],
        "brake-service" => ["Brake Pad Replacement", "Brake Fluid Change", "Brake System Inspection"],
        "battery-replacement" => ["Car Battery Installation", "Battery Testing Service", "Alternator Check"],
        "ac-repair" => ["Car AC Service", "AC Gas Refill", "AC Compressor Repair"],
        "suspension-repair" => ["Shock Absorber Replacement", "Strut Repair", "Suspension Alignment"],
        "radiator-service" => ["Radiator Flush", "Cooling System Repair", "Thermostat Replacement"],
        "transmission-repair" => ["Automatic Transmission Service", "Manual Gearbox Repair", "Clutch Adjustment"],
        "clutch-replacement" => ["Clutch Plate Replacement", "Clutch Cable Adjustment", "Flywheel Resurfacing"],
        "car-tuning" => ["Engine Performance Tuning", "ECU Remapping", "Exhaust System Upgrade"],
        
        "carpet-cleaning" => ["Deep Carpet Cleaning", "Carpet Stain Removal", "Carpet Shampooing"],
        "sofa-cleaning" => ["Fabric Sofa Cleaning", "Leather Sofa Care", "Upholstery Deep Clean"],
        "kitchen-deep-cleaning" => ["Complete Kitchen Sanitization", "Appliance Deep Clean", "Grease Removal Service"],
        "bathroom-deep-cleaning" => ["Bathroom Sanitization", "Tile and Grout Cleaning", "Mold Removal Service"],
        "window-cleaning" => ["Interior Window Cleaning", "Exterior Window Wash", "Window Frame Cleaning"],
        "floor-scrubbing" => ["Tile Floor Deep Clean", "Hardwood Floor Care", "Marble Floor Polishing"],
        "wall-washing" => ["Wall Deep Cleaning", "Paint Stain Removal", "Wallpaper Cleaning"],
        "dusting-and-mopping" => ["Regular House Cleaning", "Weekly Maintenance Clean", "Post-Construction Cleanup"],
        "mattress-cleaning" => ["Mattress Deep Sanitization", "Bed Bug Treatment", "Stain Removal Service"],
        "refrigerator-cleaning" => ["Fridge Deep Clean", "Appliance Sanitization", "Kitchen Equipment Clean"],
        "car-washing-at-home" => ["Mobile Car Wash", "Car Interior Cleaning", "Vehicle Detailing Service"],
        
        "furniture-repair" => ["Chair Repair Service", "Table Restoration", "Cabinet Door Fix"],
        "custom-furniture" => ["Custom Dining Table", "Bespoke Wardrobe", "Handcrafted Bookshelf"],
        "door-installation" => ["Interior Door Setup", "Security Door Installation", "Sliding Door Setup"],
        "cabinet-making" => ["Kitchen Cabinet Installation", "Bathroom Vanity Setup", "Storage Cabinet Build"],
        "shelf-installation" => ["Wall Shelf Mounting", "Floating Shelf Setup", "Corner Shelf Installation"],
        "wood-polishing" => ["Furniture Polish Service", "Wood Restoration", "Antique Furniture Care"],
        "window-frame-repair" => ["Wooden Window Repair", "Frame Replacement", "Window Sill Repair"],
        "wardrobe-assembly" => ["Built-in Wardrobe", "Modular Closet Setup", "Walk-in Closet Build"],
        "wood-flooring" => ["Hardwood Floor Installation", "Laminate Flooring", "Parquet Floor Setup"],
        "partition-making" => ["Room Divider Installation", "Office Partition Setup", "Decorative Screen Build"],
        "false-ceiling-work" => ["Gypsum Ceiling Installation", "POP Ceiling Work", "Suspended Ceiling Setup"],
        
        "interior-painting" => ["Room Painting Service", "Wall Color Change", "Interior Design Painting"],
        "exterior-painting" => ["House Exterior Paint", "Building Facade Painting", "Weather Protection Paint"],
        "wall-texture-design" => ["Textured Wall Finish", "Decorative Wall Art", "Designer Wall Treatment"],
        "metal-painting" => ["Gate Painting Service", "Metal Fence Paint", "Rust Prevention Coating"],
        "waterproof-coating" => ["Roof Waterproofing", "Basement Sealing", "Exterior Wall Protection"],
        "wall-putty-work" => ["Wall Preparation Service", "Surface Smoothing", "Crack Filling"],
        "spray-painting" => ["Professional Spray Paint", "Even Coating Service", "Quick Paint Job"],
        "ceiling-painting" => ["Ceiling Color Change", "Ceiling Repair Paint", "High Ceiling Service"],
        "paint-touchups" => ["Minor Paint Repair", "Spot Painting", "Color Matching Service"],
        "primer-application" => ["Wall Primer Service", "Surface Preparation", "Paint Base Coating"],
        
        "lawn-mowing" => ["Regular Grass Cutting", "Lawn Maintenance", "Garden Grass Care"],
        "weed-removal" => ["Garden Weed Control", "Lawn Weed Removal", "Plant Bed Weeding"],
        "planting-trees-shrubs" => ["Tree Plantation", "Decorative Plant Setup", "Garden Landscaping"],
        "hedge-trimming" => ["Hedge Cutting Service", "Topiary Shaping", "Bush Trimming"],
        "garden-cleaning" => ["Complete Garden Cleanup", "Yard Maintenance", "Garden Waste Removal"],
        "soil-fertilizing" => ["Lawn Fertilization", "Plant Nutrition", "Soil Treatment"],
        "pest-control-for-plants" => ["Garden Pest Management", "Plant Disease Treatment", "Organic Pest Control"],
        "watering-system-installation" => ["Drip Irrigation Setup", "Sprinkler System", "Garden Watering Solution"],
        "seasonal-flower-plantation" => ["Flower Garden Setup", "Seasonal Plant Care", "Colorful Garden Design"],
        "pruning-and-shaping" => ["Tree Pruning Service", "Plant Shaping", "Garden Maintenance"],
        "composting" => ["Organic Compost Setup", "Garden Waste Composting", "Natural Fertilizer Preparation"]
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
          
          # Select a random location for this provider
          location = locations.sample
          
          # Create service provider with password 09090909
          provider = ServiceProvider.create!(
            email: email,
            password: '09090909',
            password_confirmation: '09090909',
            full_name: "#{provider_names[category][i]} Owner",
            phone_number: "0300#{rand(1000000..9999999)}",
            category: category,
            subcategories: subcategories.sample(rand(4..6)), # Each provider handles 4-6 subcategories
            experience_years: rand(2..15),
            short_info: "Professional #{category.gsub('-', ' ')} with #{rand(2..15)} years of experience. Quality work guaranteed.",
            # Add address fields
            address: sample_addresses.sample,
            city: location[:city],
            province: location[:province],
            country: location[:country]
          )
          
          puts "Created #{category} provider: #{provider.full_name} (#{provider.email}) in #{location[:city]}"
          
          # Create 2 services for each subcategory this provider handles
          provider.subcategories.each do |subcategory|
            2.times do |j|
              # Get service names for this subcategory
              available_names = service_names[subcategory] || ["#{subcategory.gsub('-', ' ').titleize} Service", "Professional #{subcategory.gsub('-', ' ').titleize}"]
              service_name = available_names[j % available_names.length]
              
              # Set price based on category
              price = case category
                      when "electrician" then rand(800..3000)
                      when "plumber" then rand(600..2500)
                      when "mechanic" then rand(1000..5000)
                      when "house-cleaner" then rand(500..2000)
                      when "carpenter" then rand(800..4000)
                      when "painter" then rand(600..3000)
                      when "gardener" then rand(400..1500)
                      else rand(500..2000)
                      end
              
              Service.create!(
                name: service_name,
                description: "#{service_name} - Professional #{category.gsub('-', ' ')} service with experienced technicians. Contact us for quality #{subcategory.gsub('-', ' ')} services.",
                category: category,
                subcategory: subcategory,
                price: price,
                location: "#{location[:city]}, #{location[:province]}",
                provider_id: provider.id
              )
            end
          end
        end
      end

      # Create some sample clients with password 09090909
      puts "Creating sample clients..."
      5.times do |i|
        location = locations.sample
        Client.create!(
          email: "client#{i+1}@example.com",
          password: '09090909',
          password_confirmation: '09090909',
          full_name: "Client User #{i+1}",
          phone_number: "0301#{rand(1000000..9999999)}",
          # Add address fields for clients too
          address: sample_addresses.sample,
          city: location[:city],
          province: location[:province],
          country: location[:country]
        )
      end

      render json: {
        status: 'success',
        message: 'Seed data created successfully!',
        data: {
          service_providers: ServiceProvider.count,
          services: Service.count,
          clients: Client.count
        },
        login_info: {
          password: '09090909',
          service_provider_emails: provider_emails,
          client_emails: (1..5).map { |i| "client#{i}@example.com" }
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