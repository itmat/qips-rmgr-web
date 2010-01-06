require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FarmsController do

integrate_views
 
  describe "GET reconcile" do 
    it "should call reconcile a farm" do
      farm = Factory(:farm, :min => 1, :max => 1)
      get "reconcile", :id => farm.id
      Delayed::Job.reserve_and_run_one_job
      sleep 10
      farm.reload
      farm.instances.size.should == 1
      farm.instances.each { |i| i.terminate}
      
    end
  end

  describe "GET reconcile_all" do 
    it "should reconcile all farms" do
      farm1 = Factory(:farm, :min => 1, :max => 1)
      farm2 = Factory(:farm, :ami_id => TEST_AMI_2, :min => 1, :max => 1)
      get :reconcile_all
      Delayed::Job.reserve_and_run_one_job
      Delayed::Job.reserve_and_run_one_job
      sleep 10
      
      farm1.reload
      farm2.reload
      farm1.instances.size.should == 1
      farm2.instances.size.should == 1
      
      Instance.all.each { |i| i.terminate} # clean up


    end
  end

  describe "GET start_by_role" do #PLACEHOLDER
    it "should start an instance based on farm's role" do
      #TO DO WAITING FOR WORKFLOW MANAGER
    end
  end


  describe "GET process_workitem" do #PLACEHOLDER
    it "should start an instance via workitem from workflow manager." do
      #TO DO WAITING FOR WORKFLOW MANAGER
    end
  end


end
