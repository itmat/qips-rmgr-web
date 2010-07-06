class RemoveIndexesFromRecipeRoles < ActiveRecord::Migration
  def self.up
    remove_index "recipes_roles", ["recipe_id"]
    remove_index "recipes_roles", ["role_id"]
  end

  def self.down
    add_index "recipes_roles", ["recipe_id"], :name => "index_recipes_roles_on_recipe_id"
    add_index "recipes_roles", ["role_id"], :name => "index_recipes_roles_on_role_id"
  end
end
