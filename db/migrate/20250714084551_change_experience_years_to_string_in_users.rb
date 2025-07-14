class ChangeExperienceYearsToStringInUsers < ActiveRecord::Migration[8.0]
  def up
    change_column :users, :experience_years, :string
  end

  def down
    change_column :users, :experience_years, :integer
  end
end
