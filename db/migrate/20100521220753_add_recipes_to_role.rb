class AddRecipesToRole < ActiveRecord::Migration
  def self.up
    add_column :roles, :recipes, :text
  end

  def self.down
    remove_column :roles, :recipes
  end
end
