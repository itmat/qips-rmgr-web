class InstancesController < ApplicationController
  # GET /instances
  # GET /instances.xml
  
  # protect_from_forgery :except => [:state, :set_state]
  protect_from_forgery :only => [:create, :update, :destroy, :terminate]
  skip_before_filter :authenticate, :only => :set_status
  
  def index
    
    Instance.sync_with_ec2
    
    @compute_instances = Instance.all.select{|i| i.farm.farm_type.eql?('compute')}
    @admin_instances = Instance.all.select{|i| i.farm.farm_type.eql?('admin')}
    @rogues = Instance.rogue_instances

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @instances }
      format.json  { render :json => @instances }
    end
  end


  # POST /instances/1/terminate
  def terminate
    @instance = Instance.find(params[:id])
    @instance.terminate

    respond_to do |format|
      format.html { redirect_to(instances_url) }
      format.xml  { head :ok }
    end
  end
  
  # POST /instance/i-1234abcd/state  :state => 'idle', etc ## may be deprecated
  def state
    @instance = Instance.find_by_instance_id(params[:id])
    @instance.state = params[:state] if params[:state]
    @instance.save
    
    
    respond_to do |format|
      format.html { redirect_to(instances_url) }
      format.xml  { head :ok }
    end
  end  
  
  # sets status based on 
  # POST /instance/set_state  :message => <JSON_HASH>
  def set_status
    @kill = '' #kill response will eventually tell node to kill it's ruby process 
    h = JSON.parse(params[:message])
    EventLog.info "Setting state for instance #{h['instance_id']}"    
    @instance = Instance.find_by_instance_id(h['instance_id'])
    unless @instance.nil? then
      
      @instance.state = h['state'] if h['state']
      @instance.ruby_cpu_usage = h['ruby_cpu_usage'].to_f if h['ruby_cpu_usage']
      @instance.system_cpu_usage = h['system_cpu_usage'].to_f if h['system_cpu_usage']
      @instance.ruby_mem_usage = h['ruby_mem_usage'] if h['ruby_mem_usage']
      @instance.system_mem_usage = h['system_mem_usage'] if h['system_mem_usage']
      @instance.top_pid = h['top_pid'] if h['top_pid']
      @instance.ruby_pid_status = h['ruby_pid_status'] if h['ruby_pid_status']
      @instance.state_changed_at = DateTime.parse(h['timestamp']) if h['timestamp']
      @instance.executable = h['executable'] if h['executable']
      @instance.ruby_pid = h['ruby_pid'] if h['ruby_pid']
      @instance.child_procs = h['child_procs'] if h['child_procs']
      
      @instance.status_updated_at = DateTime.now
      
      #reset cycle count if idle:
      @instance.ruby_cycle_count = 0 if h['state'] && h['state'].eql?('idle')
      
      @instance.save
      
      #now check for error state
      
      if @instance.state.eql?('error')
        logger.error "Instance #{@instance.instance_id} reported following error: #{h['error_message']}"
        EventLog.error "Instance #{@instance.instance_id} reported following error: #{h['error_message']}"
        # EventLog.info "Shutting down instance #{@instance.farm.ami_id} -- #{@instance.instance_id} because of error..." unless @instance.farm.farm_type.eql?('admin')
        # @instance.terminate unless @instance.farm.farm_type.eql?('admin')
      else
        
        #but now we decide if the process needs to be killed because of process timeout
        if h['timeout']
          d = DateTime.parse(h['timestamp'])
          t = (Time.now - (h['timeout'].to_i * 60))
          
          if ((t <=> d) > 0) && @instance.state.eql?('busy') then
            
            #shut her down!
            logger.info "Shutting down instance #{@instance.farm.ami_id} -- #{@instance.instance_id} because it was busy for too long."
            EventLog.info "Shutting down instance #{@instance.farm.ami_id} -- #{@instance.instance_id} because it was busy for too long."
            @instance.terminate
            @instance.save
            
            
            # first we check cycle counts.  if ruby_cycle_count < max then cycle ruby.
            
            # if @instance.ruby_cycle_count < RUBY_CYCLE_MAX
              # cycle ruby
            #  @kill = 'KILL'    
            #  logger.info "Sending KILL notice for: Instance: #{h['instance_id']} PID: #{h['ruby_pid']}"
            #  EventLog.info "Sending KILL notice for: Instance: #{h['instance_id']} PID: #{h['ruby_pid']}"
            #  @instance.ruby_cycle_count += 1
            #  @instance.save
              
            #else
              # recycle instance entirely, unless maxed out
              # if @instance.cycle_count < NODE_CYCLE_MAX
              #  logger.info "Recycling instance #{@instance.farm.ami_id} -- #{@instance.instance_id}..."
              #  EventLog.info "Recycling instance #{@instance.farm.ami_id} -- #{@instance.instance_id}..."
              #  @instance.send_later( :recycle )
              # else
              #  logger.info "Shutting down instance #{@instance.farm.ami_id} -- #{@instance.instance_id} because it was unresponsive and exceeded max recycle tries."
              #  EventLog.info "Shutting down instance #{@instance.farm.ami_id} -- #{@instance.instance_id} because it was unresponsive and exceeded max recycle tries."
              #  @instance.terminate
              #  @instance.save
              # end
              
              
            # end
            
          end
          
          
        end
        
      end
      
    end
    
    render :layout=>false
  end  
  
  
  
  
  

end
