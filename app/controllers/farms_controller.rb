class FarmsController < ApplicationController
  before_filter :authenticate, :except => :start_by_role
  
  
  # GET /farms
  # GET /farms.xml
  def index
    @farms = Farm.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @farms }
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
        format.html { redirect_to(@farm) }
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
        format.html { redirect_to(@farm) }
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
    @num_started = @farm.start(num_start)

    if @num_started < num_start
      flash[:notice] = "Could not start all requested instances due to farm policy. Started #{@num_started} instances."
    else
      flash[:notice] = "Started #{@num_started} instances."
    end

    respond_to do |format|
      format.html { redirect_to(@farm) }
      format.xml  { head :ok }
    end
  end
  
  
  # start by role
  # looks up farm based on role, then call start!
  # looks for :role :num_start :workflow_id
  def start_by_role
    if params[:role].nil? || params[:num_start].nil? || params[:workitem_id].nil?
    
      
    else
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
    end

  end
  
  protected
  
end
