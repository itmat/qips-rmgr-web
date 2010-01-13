class AddUserDataToInstance < ActiveRecord::Migration
  def self.up
    add_column :instances, :user_data, :string
  end

  def self.down
    remove_column :instances, :user_data
  end
end
