class ChangeFarmsSpotPrice < ActiveRecord::Migration
  def self.up
    change_table :farms do |t|
      t.change :spot_price, :decimal, :precision => 10, :scale => 2
    end
  end

  def self.down
    change_table :farms do |t|
      t.change :spot_price, :decimal, :precision => 2
    end
  end
end
