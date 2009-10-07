class RemoveRecipesFromRole < ActiveRecord::Migration
  def self.up
    remove_column :roles, :recipes
  end

  def self.down
    add_column :roles, :recipes, :string  
  end
end
