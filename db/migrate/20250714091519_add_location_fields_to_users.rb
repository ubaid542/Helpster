class AddLocationFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :country, :string
    add_column :users, :province, :string
    add_column :users, :city, :string
    add_column :users, :address, :text
  end
end
