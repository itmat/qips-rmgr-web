require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InstancesController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "instances", :action => "index").should == "/instances"
    end

    it "maps #new" do
      route_for(:controller => "instances", :action => "new").should == "/instances/new"
    end

    it "maps #show" do
      route_for(:controller => "instances", :action => "show", :id => "1").should == "/instances/1"
    end

    it "maps #edit" do
      route_for(:controller => "instances", :action => "edit", :id => "1").should == "/instances/1/edit"
    end

    it "maps #create" do
      route_for(:controller => "instances", :action => "create").should == {:path => "/instances", :method => :post}
    end

    it "maps #update" do
      route_for(:controller => "instances", :action => "update", :id => "1").should == {:path =>"/instances/1", :method => :put}
    end

    it "maps #destroy" do
      route_for(:controller => "instances", :action => "destroy", :id => "1").should == {:path =>"/instances/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/instances").should == {:controller => "instances", :action => "index"}
    end

    it "generates params for #new" do
      params_from(:get, "/instances/new").should == {:controller => "instances", :action => "new"}
    end

    it "generates params for #create" do
      params_from(:post, "/instances").should == {:controller => "instances", :action => "create"}
    end

    it "generates params for #show" do
      params_from(:get, "/instances/1").should == {:controller => "instances", :action => "show", :id => "1"}
    end

    it "generates params for #edit" do
      params_from(:get, "/instances/1/edit").should == {:controller => "instances", :action => "edit", :id => "1"}
    end

    it "generates params for #update" do
      params_from(:put, "/instances/1").should == {:controller => "instances", :action => "update", :id => "1"}
    end

    it "generates params for #destroy" do
      params_from(:delete, "/instances/1").should == {:controller => "instances", :action => "destroy", :id => "1"}
    end
  end
end
