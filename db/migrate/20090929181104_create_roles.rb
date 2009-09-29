class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :name
      t.string :description
      t.string :recipes
      t.string :platform
      t.timestamps
    end
  end

  def self.down
    drop_table :roles
  end
end
