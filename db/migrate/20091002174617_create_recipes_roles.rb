class CreateRecipesRoles < ActiveRecord::Migration
  def self.up
      create_table :recipes_roles, :id => false do |t|
        t.references :role
        t.references :recipe
      end

      add_index :recipes_roles, :role_id
      add_index :recipes_roles, :recipe_id
    end

    def self.down
      drop_table :recipes_roles
    end
end
