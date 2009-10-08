class AddProvTimeToInstances < ActiveRecord::Migration
  def self.up
    add_column :instances, :prov_time, :datetime
  end

  def self.down
    remove_column :instances, :prov_time
  end
end
