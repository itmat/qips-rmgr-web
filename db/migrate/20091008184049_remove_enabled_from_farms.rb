class RemoveEnabledFromFarms < ActiveRecord::Migration
  def self.up
    remove_column :farms, :enabled
  end

  def self.down
    add_column :farms, :enabled, :boolean
  end
end
