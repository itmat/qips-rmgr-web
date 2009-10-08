class AddFarmTypeToFarms < ActiveRecord::Migration
  def self.up
    add_column :farms, :farm_type, :string
  end

  def self.down
    remove_column :farms, :farm_type
  end
end
