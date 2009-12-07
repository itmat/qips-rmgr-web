class RenameKeyGroupsInFarm < ActiveRecord::Migration
  def self.up
    rename_column :farms, :key, :key_pair_name
    rename_column :farms, :groups, :security_groups
    
  end

  def self.down
    rename_column :farms, :key_pair_name, :key
    rename_column :farms, :security_groups, :groups
    
  end
end
