require 'openwfe'

class WorkItemHelper

  def self.validate_workitem (wi)
    #work items need to have certain information in their parameters in order for the node to work
    #this method will check and see

    valid = true
    
    #first make sure this has a PID and command
    if wi.params['role'].nil? || wi.params['num_start'].nil? || wi.params['pid'].nil? 
      valid = false
    end

    return valid
  end

  def self.send_reply (workitem_id)
    puts "Sent reply for #{workitem_id}...PLACEHOLDER"
    
  end

  def self.decode_message (message)
    
    o = Base64.decode64(message)
    o = YAML.load(o)
    o = OpenWFE::workitem_from_h(o)
    o
    
  end

  def self.encode_workitem (wi)
    
    msg = wi.to_h
    msg = YAML.dump(msg)
    msg = Base64.encode64(msg)
    msg
  end
  
end
