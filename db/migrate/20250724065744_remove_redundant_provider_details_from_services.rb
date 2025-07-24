class RemoveRedundantProviderDetailsFromServices < ActiveRecord::Migration[8.0]
  def change
    # Remove redundant columns since we have provider_id relationship
    remove_column :services, :provider_name, :string
    remove_column :services, :provider_email, :string  
    remove_column :services, :provider_phone, :string
    
    # Keep provider_id as it's the foreign key we need
    # Add index for better performance
    add_index :services, :provider_id unless index_exists?(:services, :provider_id)
  end
end
