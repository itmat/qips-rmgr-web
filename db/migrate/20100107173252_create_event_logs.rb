class CreateEventLogs < ActiveRecord::Migration
  def self.up
    create_table :event_logs do |t|
      t.string :event_type, :nullable => false
      t.string :message, :nullable => false 
  
      t.timestamps
    end
  end

  def self.down
    drop_table :event_logs
  end
end
