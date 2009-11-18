class InstancesController < ApplicationController
  # GET /instances
  # GET /instances.xml
  
  # protect_from_forgery :except => [:state, :set_state]
  protect_from_forgery :only => [:create, :update, :destroy, :terminate]
  
  def index
    
    Instance.sync_with_ec2
    
    @instances = Instance.all
    @rogues = Instance.rogue_instances

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @instances }
    end
  end

  # GET /instances/1
  # GET /instances/1.xml
  def show
    Instance.sync_with_ec2
    
    @instance = Instance.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @instance }
    end
  end

  # GET /instances/new
  # GET /instances/new.xml
  def new
    @instance = Instance.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @instance }
    end
  end

  # GET /instances/1/edit
  def edit
    @instance = Instance.find(params[:id])
  end

  # POST /instances
  # POST /instances.xml
  def create
    @instance = Instance.new(params[:instance])

    respond_to do |format|
      if @instance.save
        flash[:notice] = 'Instance was successfully created.'
        format.html { redirect_to(@instance) }
        format.xml  { render :xml => @instance, :status => :created, :location => @instance }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @instance.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /instances/1
  # PUT /instances/1.xml
  def update
    @instance = Instance.find(params[:id])

    respond_to do |format|
      if @instance.update_attributes(params[:instance])
        flash[:notice] = 'Instance was successfully updated.'
        format.html { redirect_to(@instance) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @instance.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /instances/1
  # DELETE /instances/1.xml
  def destroy
    @instance = Instance.find(params[:id])
    @instance.destroy

    respond_to do |format|
      format.html { redirect_to(instances_url) }
      format.xml  { head :ok }
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
  
  # POST /instance/i-1234abcd/state  :state => 'idle', etc
  def state
    @instance = Instance.find_by_instance_id(params[:id])
    @instance.state = params[:state] if params[:state]
    @instance.cpu = params[:cpu].to_f if params[:cpu]
    @instance.top = params[:top] if params[:top]
    
    @instance.prov_time = DateTime.now if params[:state] == 'provisioning'
    
    
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
        
    @instance = Instance.find_by_instance_id(h['instance_id'])
    unless @instance.nil? then
    
      @instance.state = h['state'] if h['state']
      @instance.cpu = h['cpu'].to_f if h['cpu']
      @instance.top = h['top'] if h['top']
      @instance.state_changed_at = DateTime.parse(h['timestamp']) if h['timestamp']
      @instance.executable = h['executable'] if h['executable']
      @instance.ruby_pid = h['ruby_pid'] if h['ruby_pid']
      
      @instance.status_updated_at = DateTime.now
      @instance.save

      #but now we decide if the process needs to be killed because of process timeout
      #TODO
      

    end
    
    respond_to do |format|
      format.html { render }
      format.xml  { head :ok }
    end
  end  
  
  
  
  
  

end
