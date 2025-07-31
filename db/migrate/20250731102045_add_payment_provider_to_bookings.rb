class AddPaymentProviderToBookings < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :payment_provider, :string
    add_index :bookings, :payment_provider
  end
end
