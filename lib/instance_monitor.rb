

class InstanceMonitor < Struct.new(:instance_list, :workitem_id)
  
  MAX_FAIL_COUNT = 5
  SLEEP_TIME = 15
  
  #loops until all instances are up, then sends workitem_id for remote participant
  
  def perform
    fail_count = 0
    up_status = Array.new(instance_list.size) { |s| s = false}  #switch to true when either idle or busy
    while fail_count <= MAX_FAIL_COUNT
      #loop through instances and check to make sure status is 'idle' or 'busy'
      
      #set_status
      0.up_to(up_status.size) do |i|
        up_status[i] = true if instance_list[i].state == 'idle' || 
      end
      
      # break if all up!
      break unless up_status.include?(false)
      
      # check if we need to restart instance
      0.up_to(upstatus.size) do |i|
        unless up_status[i]
          #now we check prov_time and launch_time for timeouts
          if instance_list[i].prov_time
            #use provision time
            if instance_list[i].prov_time.advance(:minutes => instance_list[i].farm.role.prov_buffer) > DateTime.now
              #recycle!
              logger.info "Recycling instance: #{instance_list[i].instance_id}"
              fail_count += 1
              instance_list[i].terminate
              instance_list[i].recycle
            end
                  
          else
            #use launch_time
            if instance_list[i].launch_time.advance(:minutes => instance_list[i].farm.role.launch_buffer) > DateTime.now
              #recycle!
              logger.info "Recycling instance: #{instance_list[i].instance_id}"
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
  
  def send_reply
    # this is where we send a message back to the workflow engine.  right now, this is just message.
    # eventually this will post back a tcp call or something.
    logger.info "Sent success reply for workitem_id: #{workitem_id}"
    
  end
  
  
  
end