class AddDefaultUserDataToFarm < ActiveRecord::Migration
  def self.up
    add_column :farms, :default_user_data, :string
  end

  def self.down
    remove_column :farms, :default_user_data
  end
end
