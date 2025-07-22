class CreateBookings < ActiveRecord::Migration[8.0]
  def change
    create_table :bookings do |t|
      t.references :client, foreign_key: { to_table: :users }
      t.references :service_provider, foreign_key: { to_table: :users }
      t.references :service, foreign_key: true
      t.date :date
      t.string :time
      t.string :status
      t.decimal :price

      t.timestamps
    end
  end
end
