class AddTopPidRubyPidStatusToInstance < ActiveRecord::Migration
  def self.up
    add_column :instances, :top_pid, :integer
    add_column :instances, :ruby_pid_status, :string
  end

  def self.down
    remove_column :instances, :ruby_pid_status
    remove_column :instances, :top_pid
  end
end
