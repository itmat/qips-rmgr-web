require 'rubygems'
require 'right_aws'

class Instance < ActiveRecord::Base
    belongs_to :farm
    

    #start ONE instance based on it's farm.  save instance id
    def start()
      #TODO
      
    end
        
    #make the call to ec2 to terminate the machine.  change status to shutdown
    def terminate
    
      ec2.terminate_instances(@instance_id)
      @state = 'shutdown'
      save
      
      
    end
    

    ###########  COPIED FROM DAEMON
    #
    #  Here is the main method that starts things
    #  right now it just starts the instances and returns, 
    #  but it should block until everything is actually ready
    #

    def start_and_create_instances(ami, groups, key, role, num=1)
      begin
        new_instances = @ec2.run_instances(ami,num,num,groups,key, role, 'public')
        new_instances.each do |i|
          puts "InstanceStarter STARTED #{i[:aws_instance_id]} with role: #{role}"
          temp = Instance.create(:aws_instance_id => i[:aws_instance_id], :aws_image_id => i[:aws_image_id], :aws_launch_time => i[:aws_launch_time], :state => "LAUNCHED")
          temp.save
        end
      rescue
        puts "Caught exception when trying to start #{num_start} #{k} instances!"
      end

    end
    
    
    ###############################
    #   this is the main method called to sync with ec2 instances and our cache. 
    #   adds and deletes local instances as needed. COPIED FROM DAEMON
    #
    
    
    def self.sync_with_ec2
      
      #add new instances from aws to local records (should not happen often)
      ec2.describe_instances.each do |i|
        if i[:aws_state] == 'running' || i[:aws_state] == 'starting' || i[:aws_state] == 'pending' then
          # but check if we really want to save it
          unless Instance.first(:aws_instance_id => i[:aws_instance_id]) || instance_configs[i[:aws_image_id]].nil?
            temp = Instance.create(:aws_instance_id => i[:aws_instance_id], :aws_image_id => i[:aws_image_id], :aws_launch_time => i[:aws_launch_time], :state => "LAUNCHED")
            temp.save
            DaemonKit.logger.info "Added instance: #{i[:aws_image_id]} -- #{i[:aws_instance_id]} -- #{i[:aws_state]} to local record."
          end
        end
      end
      
      #FINALLY we check each of our records against what's running in aws. if instance is not there or is terminated, then delete our record!
      DaemonKit.logger.info "Cleaning up local record..."
      Instance.all.each do |i|
        #check if it's on aws
        begin
          temp = ec2.describe_instances(i.aws_instance_id)[0]
          if temp[:aws_state] == 'terminated' || temp[:aws_state] == 'shutting-down'
            i.destroy
            DaemonKit.logger.info "Removed #{i.aws_image_id} -- #{i.aws_instance_id} from local record."
          end
        rescue Exception => e
          puts e.message
          i.destroy
          DaemonKit.logger.info "Removed #{i.aws_image_id} -- #{i.aws_instance_id} from local record."
        end
      end
      
    end
            
    
    #######################################################
    #   COPIED FROM DAEMON
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
