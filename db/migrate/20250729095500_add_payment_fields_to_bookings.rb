class AddPaymentFieldsToBookings < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :payment_status, :string, default: 'pending'
    add_column :bookings, :payment_reference, :string
    add_column :bookings, :paid_at, :datetime
    
    add_index :bookings, :payment_status
  end
end