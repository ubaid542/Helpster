class CreateServices < ActiveRecord::Migration[8.0]
  def change
    create_table :services do |t|
      t.string :name
      t.text :description
      t.string :category
      t.decimal :price
      t.string :location
      t.string :provider_name
      t.string :provider_email
      t.string :provider_phone

      t.timestamps
    end
  end
end
