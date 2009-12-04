class RemoveProvBufferLaunchBufferFromRole < ActiveRecord::Migration
  def self.up
    remove_column :roles, :prov_buffer
    remove_column :roles, :launch_buffer
  end

  def self.down
    add_column :roles, :launch_buffer, :integer
    add_column :roles, :prov_buffer, :integer
  end
end
