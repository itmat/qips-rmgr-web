#DEPRECATED BECAUSE WE NO LONGER NEED TO MONITOR INSTANCE START UP

class InstanceMonitor < Struct.new(:instance_ids, :workitem_id) 
  
  MAX_FAIL_COUNT = 5
  SLEEP_TIME = 15
  
  #loops until all instances are up, then sends workitem_id for remote participant
  
  def perform
    fail_count = 0
    instance_list = InstanceMonitor.get_instances(instance_ids)
    up_status = Array.new(instance_list.size) { |s| s = false}  #switch to true when either idle or busy
    while fail_count <= MAX_FAIL_COUNT
      #loop through instances and check to make sure status is 'idle' or 'busy'

      #set_status
      up_status.size.times do |i|
        instance_list[i].reload
        puts "State for #{instance_list[i].instance_id} is: #{instance_list[i].state}"
        up_status[i] = true if instance_list[i].state == 'idle' || instance_list[i].state == 'admin' || instance_list[i].state == 'busy'
      end
      
      # break if all up!
      break unless up_status.include?(false)
      
      # check if we need to restart instance
      up_status.size.times do |i|
        unless up_status[i]
          #now we check prov_time and launch_time for timeouts
          if instance_list[i].prov_time
            #use provision time
            if instance_list[i].prov_time.advance(:minutes => instance_list[i].farm.role.prov_buffer) < DateTime.now
              #recycle!
              puts "Recycling instance: #{instance_list[i].instance_id} based on provisioning timeout"
              fail_count += 1
              instance_list[i].terminate
              instance_list[i].recycle
            end
                  
          else
            #use launch_time
            if instance_list[i].launch_time.advance(:minutes => instance_list[i].farm.role.launch_buffer) < DateTime.now
              
              #recycle!
              puts "Recycling instance: #{instance_list[i].instance_id} based on launch timeout"
              fail_count += 1
              instance_list[i].terminate
              instance_list[i].recycle
            end
            
          end

        end
      end
      
      sleep SLEEP_TIME
    end

    send_reply

  end
  
  
  def self.get_instances(instance_ids)
    #returns an array of instances based on the instance id's
    ia = []
    instance_ids.each do |id|
      ia << Instance.find(:first, :conditions => {:instance_id => id})
    end
    return ia
  
  end

  
  
  
  def send_reply
    # this is where we send a message back to the workflow engine.  right now, this is just message.
    # eventually this will post back a tcp call or something.
    puts "Sent success reply for workitem_id: #{workitem_id}"
    
  end
  
  # this method may be extraneous
  def self.send_reply(workitem_id=nil)
    # this is where we send a message back to the workflow engine.  right now, this is just message.
    # eventually this will post back a tcp call or something.
    puts "Sent success reply for workitem_id: #{workitem_id}"
    
  end
  
  
  
end