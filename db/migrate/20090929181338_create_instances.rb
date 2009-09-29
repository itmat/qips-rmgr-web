class CreateInstances < ActiveRecord::Migration
  def self.up
    create_table :instances do |t|
      t.string :instance_id
      t.decimal :cpu
      t.string :top
      t.string :state
      t.string :ec2_state
      t.integer :farm_id

      t.timestamps
    end
  end

  def self.down
    drop_table :instances
  end
end
