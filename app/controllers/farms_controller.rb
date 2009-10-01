class FarmsController < ApplicationController
  before_filter :authenticate
  
  
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
    @farm = Farm.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @farm }
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
      flash[:notice] = "Could not start all requested instances due to farm policy. Started #{num_started} instances."
    else
      flash[:notice] = "Started #{num_started} instances."
    end

    format.html { redirect_to(@farm) }
    format.xml  { head :ok }
  
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
    @farms = Farms.all
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
  
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
       username == "admin" && password == "admin"
    end
  end
  
end
