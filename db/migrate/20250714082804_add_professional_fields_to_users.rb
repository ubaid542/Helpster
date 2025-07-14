class AddProfessionalFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :category, :string
    add_column :users, :experience_years, :integer
    add_column :users, :short_info, :text
  end
end
