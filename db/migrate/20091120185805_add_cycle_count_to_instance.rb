class AddCycleCountToInstance < ActiveRecord::Migration
  def self.up
    add_column :instances, :cycle_count, :integer, :default => 0
  end

  def self.down
    remove_column :instances, :cycle_count
  end
end
