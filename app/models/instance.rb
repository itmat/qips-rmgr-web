require 'rubygems'
require 'right_aws'
require 'json'

class Instance < ActiveRecord::Base
    belongs_to :farm
    
    @ec2 = RightAws::Ec2.new(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)

    def self.get_ec2()
      @ec2 = RightAws::Ec2.new(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
      return @ec2 
    end

    # restarts an instance and then repopulates instance-id, etc 
    def recycle()
        ec2 = Instance.get_ec2
        begin
          new_instances = ec2.run_instances(farm.ami_id, 1 ,1 , farm.security_groups.split(','),farm.key_pair_name, farm.role.name, 'public', nil, farm.kernel_id)
          new_instances.each do |i|
            self.instance_id =  i[:aws_instance_id]
            self.launch_time = i[:aws_launch_time]
            self.state = "launched"
            self.ec2_state = i[:aws_state]
            
            #reset other values
            self.ruby_cpu_usage = nil
            self.system_cpu_usage = nil
            self.ruby_mem_usage = nil
            self.system_mem_usage = nil
            self.top_pid = nil
            self.ruby_pid_status = nil
            self.state_changed_at = nil
            self.executable = nil
            self.ruby_pid = nil
            self.status_updated_at = nil
            self.ruby_cycle_count = 0
            
          end
          self.cycle_count += 1
          save
          logger.info "Started and Saved Instance #{farm.ami_id} -- #{instance_id}"
        rescue => e
          logger.error "Exception caught while trying to start image #{farm.ami_id}"
          logger.error "#{e.message}\n\n#{e.backtrace}"
        end
    end
        
    #make the call to ec2 to terminate the machine.  change status to shutdown
    def terminate
      self.state = 'shutdown'
      save
      ec2 = Instance.get_ec2
      ec2.terminate_instances(instance_id)
      
    end

    ###########
    # 
    #   returns true if the instance has a state that is considered running (not shutting down)
    #

    def running?
    
      (state == 'launched' || state == 'admin' || state == 'idle' || state == 'busy' || state == 'reserved' || state == 'manual')
    end
    

    ###########
    # 
    #   returns true if the instance has a state that is considered available for jobs
    #

    def available?
      (state == 'launched' || state == 'idle')
      
    end

    ################
    #
    #  returns true if has not heard from in a while
    #

    def silent_since?(timeout = 5)

      if status_updated_at.nil?
        t1 = launch_time
      else
        t1 = status_updated_at
      end
      
      t2 = Time.now - (timeout*60)
  
      
      if (t2 <=> t1) > 0     
        return true
      else
        return false
      end
    end



    # DEPRECATED WE DON'T NEED TO SEE IF NODE IS PROVISIONED
    # def provisioned?
    #  (state == 'idle' || state == 'admin' || state == 'busy' || state == 'reserved')
    # end
    
    #######
    #  creates an instance from a typical aws hash.  finds the farm as well. 
    #
    
    def self.create_from_aws_hash(i, state=nil)
      
      set_state = state ||= 'launched'
      
      temp = nil
      
      farm = Farm.find(:first, :conditions => {:ami_id => i[:aws_image_id]})

      if farm.nil?
        logger.error "Could not find a farm for #{i[:aws_image_id]}"
        
      else
        temp = Instance.create(:instance_id => i[:aws_instance_id], :farm => farm, :launch_time => i[:aws_launch_time], :ec2_state => i[:aws_state], :state => set_state, :public_dns_name => i[:dns_name])
        temp.save     
        logger.info "Saved instance #{farm.ami_id} --- #{temp.instance_id}"
      end
      
      return temp
      
    end
    
    
    ###########  starts instance and saves in local list 
    #
    #  Here is the main method that starts things
    #  right now it just starts the instances and returns, 
    #  
    #

    def self.start_and_create_instances(ami, security_groups, key_pair_name, kernel='', role='', num=1)
      begin
        new_instances = @ec2.run_instances(ami,num,num,security_groups,key_pair_name, role, 'public', nil, kernel)
        new_instances.each do |i|
          temp = Instance.create_from_aws_hash(i)
        end
        logger.info "Started and saved #{num} #{ami} instances."
        
      rescue
        logger.error "Caught exception when trying to start #{num} #{ami} instances!"
      end

    end
    

    
    #################  SYNC LOCAL INSTANCES WITH AWS
    #
    #   this is the main method called to sync with ec2 instances and our cache. 
    #   adds and deletes local instances as needed. 
    #
    
    def self.sync_with_ec2
      
      # add new instances from aws to local records (should not happen often)
      # we only add instances that we can find farms for.  the rest we don't add
      # if we don't add then we try and sync ec2_states
      
      private_ips = Array.new  # list of private IPs for unrestricted access
      
      @ec2.describe_instances.each do |i|
       
        if inst = Instance.first(:conditions => {:instance_id => i[:aws_instance_id]})
          private_ips << IpAccessWriter.parse_ip(i[:private_dns_name]) unless i[:private_dns_name].nil?
          inst.ec2_state = i[:aws_state]
          inst.public_dns_name = i[:dns_name] unless i[:dns_name].nil?
          inst.save
        else
          unless Farm.find(:first, :conditions => {:ami_id => i[:aws_image_id]}).nil? || i[:aws_state] == 'shutting-down' || i[:aws_state] == 'terminated'
            temp = Instance.create_from_aws_hash(i, 'manual')
            private_ips << IpAccessWriter.parse_ip(i[:private_dns_name]) unless i[:private_dns_name].nil?
            logger.info "Added instance: #{i[:aws_image_id]} -- #{i[:aws_instance_id]} -- #{i[:aws_state]} to local record."
          end
        end
        
      end
      
       
      #FINALLY we check each of our records against what's running in aws. if instance is not there or is terminated, then delete our record!
      logger.info "Cleaning up local instance list..."
      Instance.all.each do |i|
        #check if it's on aws
        begin
          temp = @ec2.describe_instances(i.instance_id)[0]
          if temp[:aws_state] == 'terminated'
            i.destroy
            logger.info "Removed #{i.farm.ami_id} -- #{i.instance_id} from local record."
          end
        rescue Exception => e
          puts e.message
          i.destroy
          logger.info "Removed #{i.farm.ami_id} -- #{i.instance_id} from local record."
        end
      end
      
      IpAccessWriter.write_access_file(private_ips)     
      
      
    end
            
            
    ######################################################
    #
    #  Finds all ec2 instances that don't have farms
    #  Returns and ARRAY of HASHES representing them 
    #        
            
    def self.rogue_instances
      
      rogue_array = Array.new
      
      @ec2.describe_instances.each do |i|

        if Farm.find(:first, :conditions => {:ami_id => i[:aws_image_id]}).nil? 
          rogue_array << i

        end
      
      end
      
      return rogue_array
      
      
    end
    
            
            
    
    #######################################################
    #   COPIED FROM DAEMON TODO BASED ON SQS UPDATES -- DEPRECATED?
    #   Update_state grabs a handful of json update msgs from sqs queue
    #   It then updates all the local records from the messages
    #

    def self.update_states(sqs, queue_name)
      #we don't update if node is reserved, unless it's going busy
      q = sqs.queue(queue_name)
      q.receive_messages(10, VIS_PEEK).each do |m|
        msg = JSON.parse(m.to_s)
        instance = Instance.first(:aws_instance_id => msg[:instance_id])
        unless instance.state == 'RESERVED' && ! msg['state'] == 'BUSY'
          instance.state = msg[:state]
          instance.sqs_timeout = msg['timeout'] if msg['timeout']
        end
        m.delete
      end

    end
    
    
end
