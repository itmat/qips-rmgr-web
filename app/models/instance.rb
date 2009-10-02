require 'rubygems'
require 'right_aws'
require 'json'

class Instance < ActiveRecord::Base
    belongs_to :farm
    
    @ec2 = RightAws::Ec2.new(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)

    #start ONE instance based on it's farm.  save NEW instance id
    def start()
      
        begin
          new_instances = @ec2.run_instances(@farm.ami_id, 1 ,1 , @farm.groups.split(','),@farm.key, @farm.role.name, 'public')
          new_instances.each do |i|
            @instance_id =  i[:aws_instance_id]
            @launch_time = i[:aws_launch_time]
            @state = "launched"
            @ec2_state = i[:aws_state]
          end
          save
          logger.info "Started and Saved Instance #{@farm.ami_id} -- #{@instance_id}"
        rescue
          logger.error "Exception caught while trying to start image #{@farm.ami_id}"
        end
    end
        
    #make the call to ec2 to terminate the machine.  change status to shutdown
    def terminate
    
      ec2.terminate_instances(@instance_id)
      @state = 'shutdown'
      save
      
      
    end
    
    #######
    #  creates an instance from a typical aws hash.  finds the farm as well. 
    #
    
    def self.create_from_aws_hash(i)
      
      
      farm = Farm.find(:first, :conditions => :ami_id => :aws_image_id)

      if farm.nil?
        logger.error "Could not find a farm for #{i[:aws_image_id]}"
        
      else
        temp = Instance.create(:instance_id => i[:aws_instance_id], :farm => farm, :launch_time => i[:aws_launch_time], :ec2_state => i[:aws_state], :state => "launched")     
        logger.info "Saved instance #{farm.ami_id} --- #{temp.instance_id}"
      end
      
    end
    

    ###########  starts instance and saves in local list 
    #
    #  Here is the main method that starts things
    #  right now it just starts the instances and returns, 
    #  
    #

    def start_and_create_instances(ami, groups, key, role, num=1)      
      begin
        new_instances = @ec2.run_instances(ami,num,num,groups,key, role, 'public')
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
      
      @ec2.describe_instances.each do |i|
        if i[:aws_state] == 'running' || i[:aws_state] == 'starting' || i[:aws_state] == 'pending' then
          # but check if we really want to save it
          unless Instance.first(:instance_id => i[:aws_instance_id]) || Farm.find(:first, :conditions => {:ami_id => i[:aws_image_id]}).nil?
            temp = Instance.create_from_aws_hash(i)
            logger.info "Added instance: #{i[:aws_image_id]} -- #{i[:aws_instance_id]} -- #{i[:aws_state]} to local record."
          end
        end
      end
      
      #FINALLY we check each of our records against what's running in aws. if instance is not there or is terminated, then delete our record!
      logger.info "Cleaning up local instance list..."
      Instance.all.each do |i|
        #check if it's on aws
        begin
          temp = @ec2.describe_instances(i.aws_instance_id)[0]
          if temp[:aws_state] == 'terminated'
            i.destroy
            logger.info "Removed #{i.aws_image_id} -- #{i.aws_instance_id} from local record."
          end
        rescue Exception => e
          puts e.message
          i.destroy
          logger.info "Removed #{i.aws_image_id} -- #{i.aws_instance_id} from local record."
        end
      end
      
    end
            
    
    #######################################################
    #   COPIED FROM DAEMON TODO
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
