class ServiceProvider < User 

    has_many :bookings, foreign_key: :service_provider_id, dependent: :destroy

end