class Service < ApplicationRecord

    has_many :bookings

    belongs_to :provider, class_name: "ServiceProvider", foreign_key: "provider_id"


    validates :name, presence: true, length: { minimum: 2, maximum: 100 }
    validates :description, presence: true
    validates :category, :subcategory, presence: true
    validates :price, presence: true, numericality: { greater_than: 0 }
    validates :location, presence: true
    
    delegate :full_name, :email, :phone_number, to: :provider, prefix: true

    validate :category_must_match_provider_category
    validate :subcategory_must_be_in_provider_subcategories
    validate :provider_must_have_category

    private

    def category_must_match_provider_category
        return unless provider && category.present?
        
        unless provider.category == category
        errors.add(:category, "must match your registered category (#{provider.category})")
        end
    end

    def subcategory_must_be_in_provider_subcategories  
        return unless provider && subcategory.present?
        
        unless provider.subcategories&.include?(subcategory)
        errors.add(:subcategory, "must be one of your registered subcategories")
        end
    end

    def provider_must_have_category
        return unless provider
        
        if provider.category.blank?
        errors.add(:base, "You must complete your profile and select a category before creating services")
        end
    end


    def self.search(query, location = nil)
        results = all
        
        # If both query and location are present
        if query.present? && location.present?
            results = results.where(
            "(name ILIKE ? OR description ILIKE ? OR category ILIKE ? OR subcategory ILIKE ?) AND location ILIKE ?",
            "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%", "%#{location}%"
            )
        # If only query is present
        elsif query.present?
            results = results.where(
            "name ILIKE ? OR description ILIKE ? OR category ILIKE ? OR subcategory ILIKE ?",
            "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%"
            )
        # If only location is present
        elsif location.present?
            results = results.where("location ILIKE ?", "%#{location}%")
        # If neither is present, return empty results
        else
            return none
        end
        
        # Include provider info and order by name
        results.includes(:provider).order(:name)
    end

end
