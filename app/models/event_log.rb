class EventLog < ActiveRecord::Base
    validates_presence_of :event_type, :message
          
    def self.dump(since = 60)
      ea = Array.new
      record = ''
      if since.class.to_s.eql?('Fixnum')
        t = Time.now - (since * 60)
        ea = EventLog.find(:all, :conditions => "created_at > '#{t.to_s(:db)}'")
        
      elsif since.class.to_s.eql?('Time') || since.class.to_s.eql?('Date') || since.class.to_s.eql?('DateTime')
        
        ea = EventLog.find(:all, :conditions => "created_at > '#{since.to_s(:db)}'")
        
      else
        raise NoMethodError
        
      end
      
      ea.each do |event|
        record += "#{event.event_type.upcase}: #{event.created_at.to_s(:db)} - #{event.message}\n"
              
      end
      
      return record
      
    end
    
    def self.clear 
      
      self.destroy_all
      
    end
    
    def self.print(since = 60)
      
      puts self.dump(since)
      
    end
    
    
    
    
    def self.method_missing(method, *argv)
      if ! argv.nil? && argv.size > 0
        self.create(:event_type => "#{method}", :message => argv[0]) 
      else
        raise NoMethodError
      end
    end
    
    
end
