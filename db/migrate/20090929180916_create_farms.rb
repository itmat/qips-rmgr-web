class CreateFarms < ActiveRecord::Migration
  def self.up
    create_table :farms do |t|
      t.string :name, :nullable => false
      t.string :description
      t.string :ami_id, :nullable => false 
      t.boolean :enabled, :default => true
      t.integer :min, :default => 0
      t.integer :max, :default => 1
      t.integer :role_id

      t.timestamps
    end
  end

  def self.down
    drop_table :farms
  end
end
