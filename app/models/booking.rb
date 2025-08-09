class Booking < ApplicationRecord
  belongs_to :client, class_name: "User", foreign_key: "client_id"
  belongs_to :service_provider, class_name: "User", foreign_key: "service_provider_id"
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

  # Payment provider methods
  def paid_via_stripe?
    payment_provider == 'stripe' && paid?
  end


  def contact_details_visible_to_client?
    return false unless date.present? && time.present?
    
    # Parse the time string properly
    hour, minute = time.split(':').map(&:to_i)
    booking_datetime = date.to_datetime.in_time_zone.change(hour: hour, minute: minute)
    current_time = DateTime.current
    
    # Show contact details 30 minutes before the booking time
    (booking_datetime - 30.minutes) <= current_time && current_time <= booking_datetime
  end

  def time_until_contact_details_visible
    return nil unless date.present? && time.present?
    
    # Parse the time string properly (assuming time is stored as "HH:MM" format)
    hour, minute = time.split(':').map(&:to_i)
    booking_datetime = date.to_datetime.in_time_zone.change(hour: hour, minute: minute)
    contact_visible_time = booking_datetime - 30.minutes
    current_time = DateTime.current
    
    # Return nil if contact details are already visible or past booking time
    return nil if current_time >= contact_visible_time
    
    # Return the time difference in a human-readable format
    time_diff = contact_visible_time - current_time
    total_minutes = (time_diff/60 ).to_i
    
    if total_minutes >= 1440 # 24 hours
      days = total_minutes / 1440
      "#{days} day#{days > 1 ? 's' : ''}"
    elsif total_minutes >= 60
      hours = total_minutes / 60
      "#{hours} hour#{hours > 1 ? 's' : ''}"
    else
      "#{total_minutes} minute#{total_minutes > 1 ? 's' : ''}"
    end
  end

  private

  def date_cannot_be_in_the_past
    if date.present? && date < Date.current
      errors.add(:date, "can't be in the past")
    end
  end
  
end
