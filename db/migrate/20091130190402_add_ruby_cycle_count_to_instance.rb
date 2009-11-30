class AddRubyCycleCountToInstance < ActiveRecord::Migration
  def self.up
    add_column :instances, :ruby_cycle_count, :integer, :default => 0
  end

  def self.down
    remove_column :instances, :ruby_cycle_count
  end
end
