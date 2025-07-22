class AddProviderIdToServices < ActiveRecord::Migration[8.0]
  def change
    add_column :services, :provider_id, :bigint
  end
end
