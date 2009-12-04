class AddKernelIdToFarm < ActiveRecord::Migration
  def self.up
    add_column :farms, :kernel_id, :string
  end

  def self.down
    remove_column :farms, :kernel_id
  end
end
