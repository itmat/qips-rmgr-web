class AddChildProcsToInstance < ActiveRecord::Migration
  def self.up
    add_column :instances, :child_procs, :text
  end

  def self.down
    remove_column :instances, :child_procs
  end
end
