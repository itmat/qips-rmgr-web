class AddUserDataToFarm < ActiveRecord::Migration
  def self.up
    add_column :farms, :user_data, :string
  end

  def self.down
    remove_column :farms, :user_data
  end
end
