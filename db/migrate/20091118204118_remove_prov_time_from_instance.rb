class RemoveProvTimeFromInstance < ActiveRecord::Migration
  def self.up
    remove_column :instances, :prov_time
  end

  def self.down
   add_column :instances, :prov_time, :datetime
  end
end
