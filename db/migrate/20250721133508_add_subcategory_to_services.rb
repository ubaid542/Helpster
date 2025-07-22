class AddSubcategoryToServices < ActiveRecord::Migration[8.0]
  def change
    add_column :services, :subcategory, :string
  end
end
