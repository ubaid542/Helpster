class AddSubcategoriesToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :subcategories, :text, array: true, default: []
  end
end
