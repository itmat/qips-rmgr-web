class DropRecipes < ActiveRecord::Migration
  def self.up
	drop_table :recipes
  end

  def self.down
	create_table :recipes do |t|
		t.integer	:id 
		t.string	:name
		t.text		:description
		t.datetime	:created_at
		t.datetime	:updated_at
	end
  end
end
