require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FarmsController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "farms", :action => "index").should == "/farms"
    end

    it "maps #new" do
      route_for(:controller => "farms", :action => "new").should == "/farms/new"
    end

    it "maps #show" do
      route_for(:controller => "farms", :action => "show", :id => "1").should == "/farms/1"
    end

    it "maps #edit" do
      route_for(:controller => "farms", :action => "edit", :id => "1").should == "/farms/1/edit"
    end

    it "maps #create" do
      route_for(:controller => "farms", :action => "create").should == {:path => "/farms", :method => :post}
    end

    it "maps #update" do
      route_for(:controller => "farms", :action => "update", :id => "1").should == {:path =>"/farms/1", :method => :put}
    end

    it "maps #destroy" do
      route_for(:controller => "farms", :action => "destroy", :id => "1").should == {:path =>"/farms/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/farms").should == {:controller => "farms", :action => "index"}
    end

    it "generates params for #new" do
      params_from(:get, "/farms/new").should == {:controller => "farms", :action => "new"}
    end

    it "generates params for #create" do
      params_from(:post, "/farms").should == {:controller => "farms", :action => "create"}
    end

    it "generates params for #show" do
      params_from(:get, "/farms/1").should == {:controller => "farms", :action => "show", :id => "1"}
    end

    it "generates params for #edit" do
      params_from(:get, "/farms/1/edit").should == {:controller => "farms", :action => "edit", :id => "1"}
    end

    it "generates params for #update" do
      params_from(:put, "/farms/1").should == {:controller => "farms", :action => "update", :id => "1"}
    end

    it "generates params for #destroy" do
      params_from(:delete, "/farms/1").should == {:controller => "farms", :action => "destroy", :id => "1"}
    end
  end
end
