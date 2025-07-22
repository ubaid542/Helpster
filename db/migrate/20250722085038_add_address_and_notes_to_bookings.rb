class AddAddressAndNotesToBookings < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :address, :text
    add_column :bookings, :notes, :text
  end
end
