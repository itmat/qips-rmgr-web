class AddLaunchTimeToInstance < ActiveRecord::Migration
  def self.up
    add_column :instances, :launch_time, :datetime
  end

  def self.down
    remove_column :instances, :launch_time
  end
end
