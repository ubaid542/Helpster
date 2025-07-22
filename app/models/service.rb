class Service < ApplicationRecord

    has_many :bookings

    belongs_to :provider, class_name: "User", foreign_key: "provider_id"


end
