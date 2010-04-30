require 'rubygems'
require 'right_aws'
require 'AWS'
require 'json'
require 'base64'

class Instance < ActiveRecord::Base
    belongs_to :farm
    serialize :child_procs
    @ec2 = RightAws::Ec2.new(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
    @amazon_ec2 = AWS::EC2::Base.new(:access_key_id => AWS_ACCESS_KEY_ID, :secret_access_key => AWS_SECRET_ACCESS_KEY)

    def self.get_ec2()
      @ec2 = RightAws::Ec2.new(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
      return @ec2 
    end
    
    def self.get_amazon_ec2()
      @amazon_ec2 = AWS::EC2::Base.new(:access_key_id => AWS_ACCESS_KEY_ID, :secret_access_key => AWS_SECRET_ACCESS_KEY)
      return @amazon_ec2
    end

    ##############################
    # restarts an instance and then repopulates instance-id, etc 
    # SHOULD BE DELAYED
    #
    def recycle()
        #ec2 = Instance.get_ec2
        self.user_data = '' if self.user_data.nil? 
        begin
          if (farm.spot_price.blank? || farm.ami_spec.blank?)
            new_instances = run_spot_instances(farm.ami_id, farm.security_groups.split(','), farm.key_pair_name, farm.kernel_id, user_data, 1)
          else
            new_instances = run_spot_instances(farm.ami_id, farm.security_groups.split(','), farm.key_pair_name, farm.kernel_id, user_data, 1, farm.spot_price, farm.ami_spec)
          end
          self.terminate
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
          EventLog.info "Started and Saved Instance #{farm.ami_id} -- #{instance_id}"
        rescue => e
          logger.error "Exception caught while trying to start image #{farm.ami_id}"
          EventLog.error "Exception caught while trying to start image #{farm.ami_id}"
          logger.error "#{e.message}\n\n#{e.backtrace}"
        end
    end
        
    #make the call to ec2 to terminate the machine.  change status to shutdown
    def terminate
      self.state = 'shutdown'
      save
      ec2 = Instance.get_ec2
      begin
        ec2.terminate_instances(instance_id)
        EventLog.info "Terminated instance: #{instance_id}."
      rescue
        logger.error "Caught Exception while trying to terminate instance #{instance_id}"
        EventLog.error "Caught Exception while trying to terminate instance #{instance_id}"
      end
    end

    ###########
    # 
    #   returns true if the instance has a state that is considered running (not shutting down)
    #

    def running?
      (state == 'launched' || state == 'admin' || state == 'idle' || state == 'busy' || state == 'reserved' || state == 'manual' || state == 'provisioning')
    end
    

    ###########
    # 
    #   returns true if the instance has a state that is considered available for jobs
    #

    def available?
      (state == 'launched' || state == 'idle' || state == 'provisioning')
      
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
      
      temp = Instance.find_by_instance_id(i[:aws_instance_id])
      return temp unless temp.nil?
            
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
    
  
    ########################
    # helper method to get and instance id from amazon_ec2 interface
    #
    
    def self.getSpotInstanceId(spot_instance_request_id)
      ec2 = Instance.get_amazon_ec2
      sir = ec2.describe_spot_instance_requests(:spot_instance_request_id => spot_instance_request_id)
      instance_id = sir['spotInstanceRequestSet']['item'][0]['instanceId']
      return instance_id
    end

    #############################
    # helper method to get spot request state from amazon ec2
    #

    def self.getSpotRequestState(spot_instance_request_id)
      ec2 = Instance.get_amazon_ec2
      sir = ec2.describe_spot_instance_requests(:spot_instance_request_id => spot_instance_request_id)
      state = sir['spotInstanceRequestSet']['item'][0]['state']
      return state
    end
    
    def self.get_aws_cred_url()
      # Generates RESTful authenticated URL to get aws.rb (AWS credentials) from S3
      s3g = RightAws::S3Generator.new(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
      key = RightAws::S3Generator::Key.new(RightAws::S3::Bucket.new(s3g, 'itmat-qips'), 'aws.rb')
      return key.get(1.hour)
    end

    ###############################
    # creates spot requests for requested nodes. blocks until those instances are launched
    # SHOULD BE DELAYED OR RUN IN A DELAYED METHOD
    #

    def self.run_spot_instances(ami, security_groups, key_pair_name, kernel='', user_data='', num=1, spot_price='0.10', instance_type='c1.medium')
    	#@amazon_ec2 = AWS::EC2::Base.new(:access_key_id => AWS_ACCESS_KEY_ID, :secret_access_key => AWS_SECRET_ACCESS_KEY)
    	ec2 = Instance.get_amazon_ec2
    	right_ec2 = Instance.get_ec2
    	right_aws_hashes = Array.new
    	if (!user_data.blank?)
    	  amend_user_data = String.new
    	  line_count = 1
    	  user_data.each do |line|
    	    amend_user_data << line
    	    if (line_count == 2)
    	      amend_user_data << "cd /tmp;\n"
    	      amend_user_data << "wget -O aws.rb '#{get_aws_cred_url()}';\n"
  	      end
  	      line_count = line_count + 1
  	    end
  	    user_data = amend_user_data
  	  end
    	sirs = ec2.request_spot_instances(:image_id => ami, :security_group => security_groups, :key_name => key_pair_name, :kernel_id => kernel, :user_data => Base64.encode64(user_data), :instance_count => num, :spot_price => spot_price, :instance_type => instance_type, :launch_group => "QIPS")
    	sirs['spotInstanceRequestSet']['item'].each do |sir|
    	  sir_id = sir['spotInstanceRequestId']
    	  logger.info "Attempting to request a spot instance(s). Spot Instance Request ID: #{sir_id}"
    	  instance_id = nil
    	  while (instance_id == nil)
    	    sleep (10)
    	    instance_id = getSpotInstanceId(sir_id)
    	    state = getSpotRequestState(sir_id)
    	    break if (state == nil || state == "cancelled" || state == "failed")
        end
        if (instance_id == nil)
          logger.error "Spot Instance Request #{sir_id } was #{state}"
          #raise "Spot Instance Request #{sir_id} was #{state}. Instance was not created."
        else
          logger.info "Spot Instance Request Fulfilled.  Instance ID: #{instance_id}"
        end
        ec2.cancel_spot_instance_requests(:spot_instance_request_id => sir_id)
        right_aws_hash = right_ec2.describe_instances(instance_id)
        right_aws_hashes << right_aws_hash[0] unless instance_id.nil?
      end
      return right_aws_hashes
    end
    
    ##########################
    # starts and saves instances.  sets state to launched
    # SHOULD BE DELAYED
    #
      
    def self.start_and_create_instances(ami, security_groups, key_pair_name, kernel='', user_data='', num=1)
      logger.info "ENTERING DELAYED JOB"
      begin
        #new_instances = @ec2.run_instances(ami,num,num,security_groups,key_pair_name, user_data, 'public', nil, kernel)
        new_instances = run_spot_instances(ami, security_groups, key_pair_name, kernel, user_data, num)
        new_instances.each do |i|
          temp = Instance.create_from_aws_hash(i)
          temp.user_data = user_data
          temp.state = 'launched'
          temp.save
        end
        logger.info "Started and saved #{num} #{ami} instances."
        EventLog.info "Started and saved #{num} #{ami} instances."
      rescue Exception => e
        logger.error "Caught exception when trying to start #{num} #{ami} instances!: #{e.backtrace}"
        EventLog.error "Caught exception when trying to start #{num} #{ami} instances!: #{e.backtrace}"
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
          private_ips << IpAccessWriter.host_lookup(i[:private_dns_name]) unless i[:private_dns_name].nil?
          inst.ec2_state = i[:aws_state]
          inst.public_dns_name = i[:dns_name] unless i[:dns_name].nil?
          inst.save
        else
          unless Farm.find(:first, :conditions => {:ami_id => i[:aws_image_id]}).nil? || i[:aws_state] == 'shutting-down' || i[:aws_state] == 'terminated'
            temp = Instance.create_from_aws_hash(i, 'manual')
            private_ips << IpAccessWriter.host_lookup(i[:private_dns_name]) unless i[:private_dns_name].nil?
            logger.info "Auto-added instance: #{i[:aws_image_id]} -- #{i[:aws_instance_id]} -- #{i[:aws_state]} to local record."
            EventLog.info "Auto-added instance: #{i[:aws_image_id]} -- #{i[:aws_instance_id]} -- #{i[:aws_state]} to local record."
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
            logger.info "Auto-removed #{i.farm.ami_id} -- #{i.instance_id} from local record."
            EventLog.info "Auto-removed #{i.farm.ami_id} -- #{i.instance_id} from local record."
          end
        rescue Exception => e
          puts e.message
          i.destroy
          logger.info "Auto-removed #{i.farm.ami_id} -- #{i.instance_id} from local record."
          EventLog.info "Auto-removed #{i.farm.ami_id} -- #{i.instance_id} from local record."
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
