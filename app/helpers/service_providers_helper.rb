module ServiceProvidersHelper
  def subcategories_for(category)
    {
      "Electrician" => [
        { name: "Wiring Installation", slug: "wiring-installation", description: "Professional electrical wiring for homes and offices" },
        { name: "Lighting Fixtures", slug: "lighting-fixtures", description: "Installation and repair of all types of lighting" },
        { name: "Ceiling Fan Installation", slug: "ceiling-fan-installation", description: "Ceiling fan mounting and electrical connection" },
        { name: "Circuit Breaker Repair", slug: "circuit-breaker-repair", description: "Fix and replace faulty circuit breakers" },
        { name: "Electrical Troubleshooting", slug: "electrical-troubleshooting", description: "Diagnose and fix electrical problems" },
        { name: "Switch & Socket Installation", slug: "switch-socket-installation", description: "Install new switches and electrical outlets" },
        { name: "UPS/Inverter Installation", slug: "ups-inverter-installation", description: "Backup power system installation" },
        { name: "Generator Connection", slug: "generator-connection", description: "Generator setup and electrical connection" },
        { name: "Earthing System Setup", slug: "earthing-system-setup", description: "Electrical grounding system installation" },
        { name: "Appliance Wiring", slug: "appliance-wiring", description: "Electrical connections for home appliances" },
        { name: "Solar Panel Wiring", slug: "solar-panel-wiring", description: "Solar energy system electrical connections" }
      ],

      "Plumber" => [
        { name: "Leak Fixing", slug: "leak-fixing", description: "Repair water leaks in pipes and fixtures" },
        { name: "Pipe Installation", slug: "pipe-installation", description: "Install new water and drainage pipes" },
        { name: "Water Tank Cleaning", slug: "water-tank-cleaning", description: "Clean and sanitize water storage tanks" },
        { name: "Geyser Installation", slug: "geyser-installation", description: "Water heater installation and setup" },
        { name: "Bathroom Fittings", slug: "bathroom-fittings", description: "Install bathroom fixtures and accessories" },
        { name: "Drain Cleaning", slug: "drain-cleaning", description: "Clear blocked drains and sewers" },
        { name: "Toilet Repair", slug: "toilet-repair", description: "Fix toilet problems and installations" },
        { name: "Kitchen Sink Fixing", slug: "kitchen-sink-fixing", description: "Repair and install kitchen sinks" },
        { name: "Water Motor Installation", slug: "water-motor-installation", description: "Water pump installation and repair" },
        { name: "Seepage Detection", slug: "seepage-detection", description: "Find and fix water seepage issues" },
        { name: "Sewer Line Cleaning", slug: "sewer-line-cleaning", description: "Professional sewer line maintenance" }
      ],

      "Mechanic" => [
        { name: "Engine Repair", slug: "engine-repair", description: "Complete engine diagnostics and repair" },
        { name: "Oil Change", slug: "oil-change", description: "Regular oil change and filter replacement" },
        { name: "Tire Replacement", slug: "tire-replacement", description: "Tire installation and wheel alignment" },
        { name: "Brake Service", slug: "brake-service", description: "Brake pad replacement and brake repair" },
        { name: "Battery Replacement", slug: "battery-replacement", description: "Car battery testing and replacement" },
        { name: "AC Repair", slug: "ac-repair", description: "Air conditioning system repair and service" },
        { name: "Suspension Repair", slug: "suspension-repair", description: "Shock absorber and suspension system repair" },
        { name: "Radiator Service", slug: "radiator-service", description: "Cooling system maintenance and repair" },
        { name: "Transmission Repair", slug: "transmission-repair", description: "Gearbox and transmission system repair" },
        { name: "Clutch Replacement", slug: "clutch-replacement", description: "Clutch plate and system replacement" },
        { name: "Car Tuning", slug: "car-tuning", description: "Engine tuning and performance optimization" }
      ],

      "House Cleaner" => [
        { name: "Carpet Cleaning", slug: "carpet-cleaning", description: "Deep carpet cleaning and stain removal" },
        { name: "Sofa Cleaning", slug: "sofa-cleaning", description: "Upholstery cleaning and fabric care" },
        { name: "Kitchen Deep Cleaning", slug: "kitchen-deep-cleaning", description: "Thorough kitchen cleaning and degreasing" },
        { name: "Bathroom Deep Cleaning", slug: "bathroom-deep-cleaning", description: "Complete bathroom sanitization" },
        { name: "Window Cleaning", slug: "window-cleaning", description: "Interior and exterior window cleaning" },
        { name: "Floor Scrubbing", slug: "floor-scrubbing", description: "Deep floor cleaning and polishing" },
        { name: "Wall Washing", slug: "wall-washing", description: "Wall cleaning and stain removal" },
        { name: "Dusting and Mopping", slug: "dusting-and-mopping", description: "Regular house cleaning and maintenance" },
        { name: "Mattress Cleaning", slug: "mattress-cleaning", description: "Mattress deep cleaning and sanitization" },
        { name: "Refrigerator Cleaning", slug: "refrigerator-cleaning", description: "Appliance cleaning and maintenance" },
        { name: "Car Washing (at home)", slug: "car-washing-at-home", description: "Mobile car washing service" }
      ],

      "Carpenter" => [
        { name: "Furniture Repair", slug: "furniture-repair", description: "Fix and restore damaged furniture" },
        { name: "Custom Furniture", slug: "custom-furniture", description: "Handcrafted furniture according to specifications" },
        { name: "Door Installation", slug: "door-installation", description: "Door fitting and hardware installation" },
        { name: "Cabinet Making", slug: "cabinet-making", description: "Custom kitchen and storage cabinets" },
        { name: "Shelf Installation", slug: "shelf-installation", description: "Wall-mounted and free-standing shelves" },
        { name: "Wood Polishing", slug: "wood-polishing", description: "Furniture polishing and refinishing" },
        { name: "Window Frame Repair", slug: "window-frame-repair", description: "Wooden window frame repair and replacement" },
        { name: "Wardrobe Assembly", slug: "wardrobe-assembly", description: "Closet assembly and installation" },
        { name: "Wood Flooring", slug: "wood-flooring", description: "Hardwood and laminate flooring installation" },
        { name: "Partition Making", slug: "partition-making", description: "Room dividers and partition walls" },
        { name: "False Ceiling Work", slug: "false-ceiling-work", description: "Decorative ceiling installation" }
      ],

      "Painter" => [
        { name: "Interior Painting", slug: "interior-painting", description: "Indoor wall and ceiling painting" },
        { name: "Exterior Painting", slug: "exterior-painting", description: "Outdoor wall and building painting" },
        { name: "Wall Texture Design", slug: "wall-texture-design", description: "Decorative wall textures and patterns" },
        { name: "Wood Polishing", slug: "wood-polishing", description: "Wooden surface polishing and finishing" },
        { name: "Metal Painting", slug: "metal-painting", description: "Metal surface preparation and painting" },
        { name: "Waterproof Coating", slug: "waterproof-coating", description: "Protective waterproof paint application" },
        { name: "Wall Putty Work", slug: "wall-putty-work", description: "Wall preparation and smoothing" },
        { name: "Spray Painting", slug: "spray-painting", description: "Professional spray painting service" },
        { name: "Ceiling Painting", slug: "ceiling-painting", description: "Ceiling painting and finishing" },
        { name: "Paint Touchups", slug: "paint-touchups", description: "Minor paint repairs and touch-ups" },
        { name: "Primer Application", slug: "primer-application", description: "Surface preparation with primer" }
      ],

      "Gardener" => [
        { name: "Lawn Mowing", slug: "lawn-mowing", description: "Regular grass cutting and lawn maintenance" },
        { name: "Weed Removal", slug: "weed-removal", description: "Garden weed control and removal" },
        { name: "Planting Trees/Shrubs", slug: "planting-trees-shrubs", description: "Plant new trees and decorative plants" },
        { name: "Hedge Trimming", slug: "hedge-trimming", description: "Hedge cutting and shaping" },
        { name: "Garden Cleaning", slug: "garden-cleaning", description: "Complete garden cleanup and maintenance" },
        { name: "Soil Fertilizing", slug: "soil-fertilizing", description: "Soil treatment and fertilizer application" },
        { name: "Pest Control for Plants", slug: "pest-control-for-plants", description: "Plant disease and pest management" },
        { name: "Watering System Installation", slug: "watering-system-installation", description: "Irrigation system setup" },
        { name: "Seasonal Flower Plantation", slug: "seasonal-flower-plantation", description: "Seasonal flower planting and care" },
        { name: "Pruning and Shaping", slug: "pruning-and-shaping", description: "Plant pruning and tree shaping" },
        { name: "Composting", slug: "composting", description: "Organic compost preparation and application" }
      ]
    }[category] || []
  end

  # Helper method to get just the names (for backward compatibility)
  def subcategory_names_for(category)
    subcategories_for(category).map { |sub| sub[:name] }
  end

  # Helper method to get subcategory by slug
  def find_subcategory_by_slug(category, slug)
    subcategories_for(category).find { |sub| sub[:slug] == slug }
  end
end



















































# module ServiceProvidersHelper
#   def subcategories_for(category)
#     {
#       "Electrician" => [
#     "Wiring Installation", "Lighting Fixtures", "Ceiling Fan Installation",
#     "Circuit Breaker Repair", "Electrical Troubleshooting", "Switch & Socket Installation",
#     "UPS/Inverter Installation", "Generator Connection", "Earthing System Setup",
#     "Appliance Wiring", "Solar Panel Wiring"
#   ],

#   "Plumber" => [
#     "Leak Fixing", "Pipe Installation", "Water Tank Cleaning",
#     "Geyser Installation", "Bathroom Fittings", "Drain Cleaning",
#     "Toilet Repair", "Kitchen Sink Fixing", "Water Motor Installation",
#     "Seepage Detection", "Sewer Line Cleaning"
#   ],

#   "Mechanic" => [
#     "Engine Repair", "Oil Change", "Tire Replacement",
#     "Brake Service", "Battery Replacement", "AC Repair",
#     "Suspension Repair", "Radiator Service", "Transmission Repair",
#     "Clutch Replacement", "Car Tuning"
#   ],

#   "House Cleaner" => [
#     "Carpet Cleaning", "Sofa Cleaning", "Kitchen Deep Cleaning",
#     "Bathroom Deep Cleaning", "Window Cleaning", "Floor Scrubbing",
#     "Wall Washing", "Dusting and Mopping", "Mattress Cleaning",
#     "Refrigerator Cleaning", "Car Washing (at home)"
#   ],

#   "Carpenter" => [
#     "Furniture Repair", "Custom Furniture", "Door Installation",
#     "Cabinet Making", "Shelf Installation", "Wood Polishing",
#     "Window Frame Repair", "Wardrobe Assembly", "Wood Flooring",
#     "Partition Making", "False Ceiling Work"
#   ],

#   "Painter" => [
#     "Interior Painting", "Exterior Painting", "Wall Texture Design",
#     "Wood Polishing", "Metal Painting", "Waterproof Coating",
#     "Wall Putty Work", "Spray Painting", "Ceiling Painting",
#     "Paint Touchups", "Primer Application"
#   ],

#   "Gardener" => [
#     "Lawn Mowing", "Weed Removal", "Planting Trees/Shrubs",
#     "Hedge Trimming", "Garden Cleaning", "Soil Fertilizing",
#     "Pest Control for Plants", "Watering System Installation",
#     "Seasonal Flower Plantation", "Pruning and Shaping", "Composting"
#   ]
#     }[category] || []
#   end
# end