require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FarmsController do

  def mock_farm(stubs={})
    @mock_farm ||= mock_model(Farm, stubs)
  end

  describe "GET index" do #PLACEHOLDER
    it "assigns all farms as @farms" do
      Farm.stub!(:find).with(:all).and_return([mock_farm])
      get :index
      assigns[:farms].should == [mock_farm]
    end
  end

  describe "GET reconcile" do #PLACEHOLDER
    it "should call reconcile a farm" do
      Farm.stub!(:find).with(:all).and_return([mock_farm])
      get :index
      assigns[:farms].should == [mock_farm]
    end
  end

  describe "GET reconcile_all" do #PLACEHOLDER
    it "should reconcile all farms" do
      Farm.stub!(:find).with(:all).and_return([mock_farm])
      get :index
      assigns[:farms].should == [mock_farm]
    end
  end

  describe "GET start_by_role" do #PLACEHOLDER
    it "should start an instance based on farm's role" do
      Farm.stub!(:find).with(:all).and_return([mock_farm])
      get :index
      assigns[:farms].should == [mock_farm]
    end
  end


  describe "GET process_workitem" do #PLACEHOLDER
    it "should start an instance via workitem from workflow manager." do
      Farm.stub!(:find).with(:all).and_return([mock_farm])
      get :index
      assigns[:farms].should == [mock_farm]
    end
  end


end
