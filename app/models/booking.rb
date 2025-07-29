class Booking < ApplicationRecord
  belongs_to :client, class_name: "Client"
  belongs_to :service_provider, class_name: "ServiceProvider"
  belongs_to :service

  # Validations
  validates :date, presence: true
  validates :time, presence: true
  validates :address, presence: true
  validates :status, presence: true, inclusion: { in: %w[pending confirmed cancelled completed] }
  validates :price, presence: true, numericality: { greater_than: 0 }

  # Ensure the date is not in the past
  validate :date_cannot_be_in_the_past

  # Payment status methods
  def paid?
    payment_status == 'paid'
  end

  def requires_payment?
    status == 'completed' && payment_status != 'paid'
  end

  def payment_pending?
    payment_status.nil? || payment_status == 'pending'
  end

  private

  def date_cannot_be_in_the_past
    if date.present? && date < Date.current
      errors.add(:date, "can't be in the past")
    end
  end
  
end
