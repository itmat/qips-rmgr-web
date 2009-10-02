class Farm < ActiveRecord::Base
  has_many :instances
  belongs_to :role

  #### start N instances from farm. mind upper limits
  #
  #   returns actual number started  
  #
    
  def start(num_requested=1)
    #TODO  COPIED FROM DAEMON  
    
    # find instances with that image id
    logger.info "Considering request to start #{num_request} #{@role.name} instances "

    total_running = Instance.all(:aws_image_id => conf, 
                                 :conditions => ["(state = ? OR state = ? OR state = ? OR state = ?)", 'LAUNCHED', "IDLE", 'BUSY', 'RESERVED']).size

    node_array = Instance.all(:aws_image_id => conf, 
                              :conditions => ["(state = ? OR state = ?) ", 'LAUNCHED', "IDLE"]) 

    if total_running >= instance_configs[conf]['max_running']
           #Then simpy return the workitem, we reached our limit and they'll just have to wait!
           DaemonKit.logger.info "Instance limit for #{role_request} reached. Will not start any more instances."
           #lets reserve all nodes so they don't get shutdown in the meantime.
           node_array.each do |node|
             node.state = 'RESERVED'
             node.save
           end
           q_fin.push(WorkItemHelper.encode_workitem(wi))
           m.delete
    else
           # reserve those nodes that are running, and then start / create the balance
           node_array.each do |node|
             node.state = 'RESERVED'
             node.save
             num_request = num_request - 1
             break if num_request == 0 
           end

           #now lets start the rest of the nodes needed, assuming we don't go past the max limit!

           #first lets get a count of how many nodes are LAUNCHED, IDLE, BUSY, or RESERVED
           total_left =  instance_configs[conf]['max_running'] - total_running
           num_to_start = total_left < num_request ? total_left : num_request

           DaemonKit.logger.info "Starting #{num_to_start} more instances for #{role_request} jobs."
           Thread.new(wi.pid) do
             msg_copy = m
             ins = InstanceStarter.new(ec2)
             ins.start_instances(conf,instance_configs[conf]['aws_groups'],instance_configs[conf]['aws_key'], instance_configs[conf]['role'], num_to_start)
             DaemonKit.logger.info "Finished starting instances for job #{wi.pid}."
             q_fin.push(msg_copy.to_s)
             msg_copy.delete
           end

    end
    
    
    
    # based on upper limits need to insert logic here to figure out how many we need to start
    
    #finally start appropriate amount of instances. and return that amount
    
  end


  ####  reconcile with ec2.  start / stop based on min / max. clean up, etc. 
  #
  #  returns hash with following values: message, num_started, num_shutdown
  #
  
  def reconcile
    #TODO
    
    #First sync instances 
    
    
    #then make sure this farm is operating withing limits... start and stop based on limits
    
    
    # shutdown what we can from idle
    
    
  end


end
