class RemoveCpuTopFromInstance < ActiveRecord::Migration
  def self.up
    remove_column :instances, :cpu
    remove_column :instances, :top
  end

  def self.down
    add_column :instances, :top, :string
    add_column :instances, :cpu, :decimal
  end
end
