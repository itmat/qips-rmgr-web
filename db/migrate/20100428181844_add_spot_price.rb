class AddSpotPrice < ActiveRecord::Migration
  def self.up
    change_table :farms do |t|
      t.string  :ami_spec
      t.decimal :spot_price, :precision => 2
    end
  end

  def self.down
    change_table :farms do |t|
      t.remove :ami_spec
      t.remove :spot_price
    end
  end
end
