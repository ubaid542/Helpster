class Booking < ApplicationRecord
  belongs_to :client, class_name: "Client"
  belongs_to :service_provider, class_name: "ServiceProvider"
  belongs_to :service
end
