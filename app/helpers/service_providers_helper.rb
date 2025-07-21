module ServiceProvidersHelper
  def subcategories_for(category)
    {
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
    }[category] || []
  end
end