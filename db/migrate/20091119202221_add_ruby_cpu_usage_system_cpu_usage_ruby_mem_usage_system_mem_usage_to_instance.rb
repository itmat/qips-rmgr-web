class AddRubyCpuUsageSystemCpuUsageRubyMemUsageSystemMemUsageToInstance < ActiveRecord::Migration
  def self.up
    add_column :instances, :ruby_cpu_usage, :decimal
    add_column :instances, :system_cpu_usage, :decimal
    add_column :instances, :ruby_mem_usage, :integer
    add_column :instances, :system_mem_usage, :integer
  end

  def self.down
    remove_column :instances, :system_mem_usage
    remove_column :instances, :ruby_mem_usage
    remove_column :instances, :system_cpu_usage
    remove_column :instances, :ruby_cpu_usage
  end
end
