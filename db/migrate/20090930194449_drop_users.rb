class DropUsers < ActiveRecord::Migration
  
  def self.down
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :privilege
      t.string :password
      t.string :password_confirmation

      t.timestamps
    end
  end

  def self.up
    drop_table :users
  end
  
end
