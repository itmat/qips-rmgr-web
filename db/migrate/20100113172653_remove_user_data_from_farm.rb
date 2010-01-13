class RemoveUserDataFromFarm < ActiveRecord::Migration
  def self.up
    remove_column :farms, :user_data
  end

  def self.down
    add_column :farms, :user_data, :string
  end
end
