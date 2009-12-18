require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InstancesController do

  def mock_instance(stubs={})
    @mock_instance ||= mock_model(Instance, stubs)
  end


  describe "GET index" do
    it "assigns all instances as @instances" do
      Instance.stub!(:find).with(:all).and_return([mock_instance])
      get :index
      assigns[:instances].should == [mock_instance]
    end
  end

  describe "GET set_status" do #PLACEHOLDER
    it "fills in the vars of an instance during set status message" do
      Instance.stub!(:find).with(:all).and_return([mock_instance])
      get :index
      assigns[:instances].should == [mock_instance]
    end
  end
 
  describe "GET set_status" do #PLACEHOLDER
    it "send KILL response if ruby times out.  Also increments ruby cycle count." do
      Instance.stub!(:find).with(:all).and_return([mock_instance])
      get :index
      assigns[:instances].should == [mock_instance]
    end
  end

  describe "GET set_status" do #PLACEHOLDER
    it "does NOT send KILL response normally." do
      Instance.stub!(:find).with(:all).and_return([mock_instance])
      get :index
      assigns[:instances].should == [mock_instance]
    end
  end
  
  
  describe "GET set_status" do #PLACEHOLDER
    it "send KILL response if ruby times out, but recycles node when cycle count > MAX." do
      Instance.stub!(:find).with(:all).and_return([mock_instance])
      get :index
      assigns[:instances].should == [mock_instance]
    end
  end
  
  describe "GET set_status" do #PLACEHOLDER
    it "send KILL response if ruby times out, but not when cycle count > MAX. should shut down a node that exceeds MAX CYCLE" do
      Instance.stub!(:find).with(:all).and_return([mock_instance])
      get :index
      assigns[:instances].should == [mock_instance]
    end
  end
  

end
