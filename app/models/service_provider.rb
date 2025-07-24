class ServiceProvider < User 

    has_many :bookings, foreign_key: :service_provider_id, dependent: :destroy

    has_many :services, foreign_key: :provider_id, dependent: :destroy

    # Validations for category completeness
    validates :category, presence: true, if: :creating_services?
    validates :subcategories, presence: true, if: :creating_services?

    # Helper method to check if provider can create services
    def can_create_services?
        category.present? && subcategories.present? && subcategories.any?
    end

    # Get available subcategories for this provider
    def available_subcategories
        subcategories || []
    end

    private

    def creating_services?
        services.any?
    end

end