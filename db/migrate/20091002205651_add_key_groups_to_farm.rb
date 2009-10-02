class AddKeyGroupsToFarm < ActiveRecord::Migration
  def self.up
    add_column :farms, :key, :string
    add_column :farms, :groups, :string
  end

  def self.down
    remove_column :farms, :groups
    remove_column :farms, :key
  end
end
