class FarmsController < ApplicationController
  
  skip_before_filter :authenticate, :only => ['reconcile', 'reconcile_all']
    
  # GET /farms
  # GET /farms.xml
  def index
    @farms = Farm.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @farms }
      format.json  { render :json => @farms }
    end
  end

  # GET /farms/1
  # GET /farms/1.xml
  def show
    
    Instance.sync_with_ec2
    
    @farm = Farm.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @farm }
      format.json  { render :json => @farm }
    end
  end

  # GET /farms/new
  # GET /farms/new.xml
  def new
    @farm = Farm.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @farm }
    end
  end

  # GET /farms/1/edit
  def edit
    @farm = Farm.find(params[:id])
  end

  # POST /farms
  # POST /farms.xml
  def create
    @farm = Farm.new(params[:farm])

    respond_to do |format|
      if @farm.save
        flash[:notice] = 'Farm was successfully created.'
        format.html { redirect_to(farms_path) }
        format.xml  { render :xml => @farm, :status => :created, :location => @farm }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @farm.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /farms/1
  # PUT /farms/1.xml
  def update
    @farm = Farm.find(params[:id])

    respond_to do |format|
      if @farm.update_attributes(params[:farm])
        flash[:notice] = 'Farm was successfully updated.'
        format.html { redirect_to(farms_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @farm.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /farms/1
  # DELETE /farms/1.xml
  def destroy
    @farm = Farm.find(params[:id])
    @farm.destroy

    respond_to do |format|
      format.html { redirect_to(farms_url) }
      format.xml  { head :ok }
    end
  end
  
  #start some instances from a farm
  # POST /farms/1/start
  # post num_start
  def start
    @farm = Farm.find(params[:id])
    num_start = params[:num_start].to_i ||= 1
    user_data = params[:user_data] ||= ''
    @num_started = @farm.start(num_start, nil, user_data)
    logger.info "TEST"
    if @num_started < num_start
      flash[:notice] = "Could not start all requested instances due to farm policy. Starting #{@num_started} instances.. may take a few moments."
    else
      flash[:notice] = "Starting #{@num_started} instances... may take a few moments."
    end

    respond_to do |format|
      format.html { redirect_to(@farm) }
      format.xml  { head :ok }
    end
  end
  
  #start some compute nodes from a  farm
  # POST /farms/start_compute_nodes/2
  # post num_requested
  def start_compute_instances
    @farm = Farm.find(:first, :conditions => {:name => "Compute Node"})
    num_requested = params[:num_requested].to_i ||= 1
    user_data = params[:user_data] ||= ''
    @num_started = @farm.start(num_requested, nil, user_data)
    logger.info("Requested #{num_requested} compute instances")
    logger.info("#{@num_started} compute instances started.")
    
    if @num_started < num_requested
      flash[:notice] = "Could not start all requested compute nodes due to farm policy.  Starting #{@num_started} compute instances.. may take a few moments."
    else
      flash[:notice] = "Starting #{@num_started} compute instances.. may take a few moments."
    end
    
    respond_to do |format|
      format.html { head :created }
      format.xml  { head :created }
      format.json { head :created }
    end
  end
  
  
  # start by role
  # looks up farm based on role, then call start!
  # looks for :role :num_start :workflow_id
  def start_by_role

    unless params[:role].nil? || params[:num_start].nil? || params[:workitem_id].nil?
      begin
        role = Role.find(:first, :conditions => {:name => params[:role]})
        @farm = Farm.find(:first, :conditions => {:role_id => role})
        
        @num_started = @farm.start(params[:num_start], params[:workitem_id])
      
      rescue => e
        
        logger.error "Exception Caught while trying to start_by_role:"
        logger.error "#{e.message}"
        logger.error "#{e.backtrace}"
      
      
      end
      
      respond_to do |format|
        format.html { redirect_to(@farm) }
        format.xml  { head :ok }
      end
      
      
    end
    
    
  end
  
  ####################
  #
  #  very similar to start_by_role, except get everything from /POST :workitem
  #
  
  def process_workitem

    unless params[:workitem].nil? 
      
      #first we decode and validate the workitem
      wi = WorkItemHelper.decode_message(params[:workitem])
      if WorkItemHelper.validate_workitem(wi)
      
        begin
          role = Role.find(:first, :conditions => {:name => wi.params['role']})
          @farm = Farm.find(:first, :conditions => {:role_id => role})
        
          @num_started = @farm.start(wi.params['num_start'], wi.params['pid'])
      
        rescue => e
        
          logger.error "Exception Caught while trying to start_by_workitem:"
          logger.error "#{e.message}"
          logger.error "#{e.backtrace}"
      
      
        end
      
      else
        
        flash[:notice] = "Could not start instances based on workitem."
      
      end
      
    end    

    respond_to do |format|
      format.html { redirect_to(@farm) }
      format.xml  { head :ok }
    end
    
    
    
  end
  
  
  
  # reconcile a farm
  # POST /farms/1/reconcile
  def reconcile 
    @farm = Farm.find(params[:id])
    @report = @farm.reconcile
    respond_to do |format|
      format.html { render }
      format.xml  { head :ok }
    end

  end
  
  # reconcile all farms
  # POST /farms/reconcile_all
  def reconcile_all
    @farms = Farm.all
    @reports = Array.new

    @farms.each do |farm|
      @reports << farm.reconcile

    end
    
    respond_to do |format|
      format.html { render }
      format.xml  { head :ok }
      format.json  { head :ok}
    end

  end
  
  protected
  
end
