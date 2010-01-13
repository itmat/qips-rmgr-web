class Farm < ActiveRecord::Base
  # Columns 
  # t.string :name
  # t.string :description
  # t.string :ami_id
  # t.integer :min
  # t.integer :max
  # t.integer :role_id
  # t.timestamps
  # t.string :farm_type # may rename ?
  # t.string :key_pair_name # AWS pem key
  # t.string :security_groups # AWS security groups comma-delimited list
  
  validates_presence_of :name, :ami_id, :security_groups, :key_pair_name, :min, :max
  
  has_many :instances
  belongs_to :role

  #before save removes any whitespace from the string.  this is so split will give us a clean array
  before_save :strip_groups, :destroy_instances_if_ami_changed


  #### start N instances from farm. mind upper limits
  #
  #   returns actual number started  
  #
    
  def start(num_requested=1, workitem_id=nil, user_data=nil)
    
    # find instances with that image id
    logger.info "Considering request to start #{num_requested} #{role.name} instances "

    total_running = (instances.select{ |i| i.running? }).size
    
    node_array = instances.select{ |i| i.available? }

    num_to_start = 0
 
    if total_running >= max
      logger.info "Instance limit for #{num_requested} reached. Will not start any more instances."
      #lets reserve all nodes so they don't get shutdown in the meantime.
      node_array.each do |node|
        node.state = 'reserved'
        node.save
      end
      WorkitemHelper.send_reply(workitem_id) unless workitem_id.nil?
           
    else
      logger.info "Reserving for: #{num_requested} #{role.name} instances "
      # reserve those nodes that are running, and then start / create the balance
      node_array.each do |node|
         node.state = 'reserved'
         node.save
         num_requested = num_requested.to_i - 1
         break if num_requested == 0 
       end

      #now lets start the rest of the nodes needed, assuming we don't go past the max limit!
      #first lets get a count of how many nodes are LAUNCHED, IDLE, BUSY, or RESERVED
      total_left =  max - total_running
      num_to_start = total_left < num_requested.to_i ? total_left : num_requested.to_i

            
      #start num_to_start instances via Instance. Enqueue these in delayed job because they may take a while
      Instance.send_later(:start_and_create_instances, ami_id,security_groups.split(','),key_pair_name, kernel_id, user_data ||= '', num_to_start)
      
      #now also enqueue the workitem reply if needed
      WorkItemHelper.send_later(:send_reply, workitem_id) unless workitem_id.nil?
      
      logger.info "Starting #{num_to_start} more #{ami_id} instances. Note that this may take a moment. "
      EventLog.info "Starting #{num_to_start} more #{ami_id} instances. Note that this may take a moment. "
      
    end
    
    return num_to_start
    
    
  end


  ####  reconcile with ec2.  start / stop based on min / max. clean up, etc. 
  #
  #  returns hash with following values: message, num_started, num_shutdown
  #
  
  def reconcile
    
    #First sync instances 
    Instance.sync_with_ec2
    
    #then make sure this farm is operating withing limits... start and stop based on limits
    #now lets go through our configs and sync what is running with what is configured to run

    num_stop = 0
    num_start = 0

    logger.info "Reconciling farm #{ami_id}..."
    EventLog.info "Reconciling farm #{ami_id}..."
    
    ia = instances.select{ |i| i.running?} 
    if ia.size < min
      num_start = min.to_i - ia.size
      # need to start some of them
      logger.info "Attempting to start #{num_start} #{ami_id} instances... may take a few moments."
      EventLog.info "Attempting to start #{num_start} #{ami_id} instances... may take a few moments."
      Instance.send_later(:start_and_create_instances, ami_id,security_groups.split(','),key_pair_name, kernel_id, default_user_data, num_start)

    elsif ia.size > max
      # need to stop some of the instances, if they are either 'IDLE' or 'LAUNCHED' state
      num_stop = ia.size - max.to_i
      count = 0
      ia.each do |ri|
        break if count >= num_stop
        if ri.available? 
          #shut it down!
          logger.info "Shutting down instance #{ami_id} -- #{ri.instance_id}..."
          EventLog.info "Shutting down instance #{ami_id} -- #{ri.instance_id}..."
          ri.terminate
          count += 1
        end  
      end
    end
    
    # shutdown what we can from idle
    
    num_stop += scale_down
    
    #########################
    #
    #   now that we scaled down, lets recycle those compute nodes that have not checked in for a while (15 mins)
    #   we're looking for those that are available or busy and are compute nodes
    #
    
    ia = instances.select{ |i| i.running?} 
    
    ia.each do |ri|
      if (ri.available? || ri.state.eql?('busy')) && ri.farm.farm_type.eql?('compute') && ri.silent_since?(NODE_TIMEOUT)
        #recycle if not heard from in a while
        if ri.cycle_count < NODE_CYCLE_MAX
          logger.info "Recycling instance #{ri.farm.ami_id} -- #{ri.instance_id}..."
          EventLog.info "Recycling instance #{ri.farm.ami_id} -- #{ri.instance_id}..."
          ri.terminate
          ri.recycle
          ri.save
        else
          logger.info "Shutting down instance #{ri.farm.ami_id} -- #{ri.instance_id} because it was unresponsive and exceeded max recycle tries."
          EventLog.info "Shutting down instance #{ri.farm.ami_id} -- #{ri.instance_id} because it was unresponsive and exceeded max recycle tries."
          ri.terminate          
        end
      end  
    end
    
    
    return {:farm_name => name, :message => 'Finished reconciling', :num_shutdown => num_stop, :num_started => num_start}
    
  end

  #####################################
  #
  #   scales down when there are idle instances
  #   returns number that we shutdown
  #

  def scale_down
    
    num_stopped = 0
    # lets figure out what we can shut down.
    logger.info "Looking for unused instances to scale down..."
    EventLog.info "Looking for unused instances to scale down..."
    instances.each do |i|
      #this is actually pretty complicated.  we have to figure out the exact range for each instance, based on the instance launch time
      lt = i.launch_time
      lt_diff = 60 - lt.min
      lower_range = HOUR_MOD - lt_diff #careful, it could be negative!
      lower_range = lower_range + 60 if lower_range < 0 # adjust for negative!

      upper_range = lower_range + (60 - HOUR_MOD) #upper range for mins, could be > 59!
      upper_range = upper_range - 60 if upper_range > 59 #correct for over 59

      now_min = DateTime.now.min
 
      ###  DEBUG shutdown logic
      # puts "Instance: #{i.aws_instance_id}"
      # puts "Now: #{now_min}"
      # puts "Upper: #{upper_range}"
      # puts "Lower: #{lower_range}"

      if (now_min > lower_range && now_min < upper_range) || ((upper_range < lower_range) && (now_min < upper_range || now_min > lower_range))
        #so lets shutdown, but only if it won't bring us below the min_running threshold

        #first find out how many instances are running of this type
        total_running = (instances.select{ |j| j.running? }).size
        unless ((total_running - 1) <  min ||  (! i.available?) )
          # for now we shutdown via aws but this will change as we figure out a better way
          logger.info "Shutting down #{i.farm.ami_id} -- #{i.instance_id} due to IDLE timeout."
          EventLog.info "Shutting down #{i.farm.ami_id} -- #{i.instance_id} due to IDLE timeout."
          i.terminate
          num_stopped += 1
        end
      end
    end

    return num_stopped

  end

  #before save removes any whitespace from the string.  this is so split will give us a clean array
  def strip_groups
    security_groups.gsub!(/\s/,'') unless security_groups.nil?
  end

  #before save removes any instances from farm.  this prevents bug where you might see duplicate instances
  def destroy_instances_if_ami_changed
    self.instances.each { |i| i.destroy } if self.ami_id_changed?
  end
  


end
