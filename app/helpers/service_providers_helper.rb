module ServiceProvidersHelper
  def subcategories_for(category)
    {
      "Electrician" => ["Wiring", "Lighting", "Fan Installation"],
      "Plumber" => ["Leak Fixing", "Pipe Installation", "Water Tank Repair"],
      "Mechanic" => ["Engine Repair", "Oil Change", "Tire Replacement"],
      "House Cleaner" => ["car washer", "Carpet Cleaner", "Tire Replacement"],
      "Carpenter" => ["Engine Repair", "Oil Change", "Tire Replacement"],
      "Painter" => ["Engine Repair", "Oil Change", "Tire Replacement"],
      "Gardener" => ["Engine Repair", "Oil Change", "Tire Replacement"]
    }[category] || []
  end
end
