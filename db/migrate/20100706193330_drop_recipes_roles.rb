class DropRecipesRoles < ActiveRecord::Migration
  def self.up
    drop_table "recipes_roles"
  end

  def self.down
    create_table "recipes_roles", :id => false, :force => true do |t|
      t.integer "role_id"
      t.integer "recipe_id"
    end
  end
end
