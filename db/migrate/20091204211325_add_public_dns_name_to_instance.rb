class AddPublicDnsNameToInstance < ActiveRecord::Migration
  def self.up
    add_column :instances, :public_dns_name, :string
  end

  def self.down
    remove_column :instances, :public_dns_name
  end
end
