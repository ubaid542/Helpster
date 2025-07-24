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





end
