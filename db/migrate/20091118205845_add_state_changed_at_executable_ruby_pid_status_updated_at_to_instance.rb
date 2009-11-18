class AddStateChangedAtExecutableRubyPidStatusUpdatedAtToInstance < ActiveRecord::Migration
  def self.up
    add_column :instances, :state_changed_at, :datetime
    add_column :instances, :executable, :string
    add_column :instances, :ruby_pid, :integer
    add_column :instances, :status_updated_at, :datetime
  end

  def self.down
    remove_column :instances, :status_updated_at
    remove_column :instances, :ruby_pid
    remove_column :instances, :executable
    remove_column :instances, :state_changed_at
  end
end
