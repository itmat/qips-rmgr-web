class AddProvBufferLaunchBufferToRoles < ActiveRecord::Migration
  def self.up
    add_column :roles, :prov_buffer, :integer
    add_column :roles, :launch_buffer, :integer
  end

  def self.down
    remove_column :roles, :launch_buffer
    remove_column :roles, :prov_buffer
  end
end
