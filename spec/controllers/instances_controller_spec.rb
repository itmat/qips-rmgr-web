require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'json'

describe InstancesController do
  integrate_views

  default_message = {
    :instance_id => 'i-abcd1234',
    :state => 'busy',
    :ruby_cpu_usage => 12.34,
    :system_cpu_usage => 23.45,
    :ruby_mem_usage => 34,
    :system_mem_usage => 45,
    :top_pid => 5678,
    :ruby_pid_status => 'zombie',
    :timestamp => "#{Time.now}",
    :executable => 'sleep',
    :timeout => 60,
    :ruby_pid => 7890      
       }

  describe "GET set_status" do 
    it "should fill in the vars of an instance during set status message" do
      instance = Factory(:instance, :instance_id => 'i-abcd1234')
      get :set_status, :message => default_message.to_json
       
      instance.reload 
      instance.state.should == 'busy'
      instance.ruby_cpu_usage.should == 12.34
      instance.system_cpu_usage.should == 23.45
      instance.ruby_mem_usage.should == 34
      instance.system_mem_usage.should == 45
      instance.top_pid.should == 5678
      instance.ruby_pid_status.should == 'zombie'
      instance.executable.should == 'sleep'
      instance.ruby_pid.should == 7890
      instance.state_changed_at.should == DateTime.parse(default_message[:timestamp])
       
    end
  end

  describe "GET set_status" do 
    it "should NOT send KILL response normally." do
      instance = Factory(:instance, :instance_id => 'i-abcd1234')
      get :set_status, :message => default_message.to_json
      response.body.should_not match /KILL/
    end
  end

  describe "GET set_status" do 
    it "should send KILL response if ruby times out.  Also increments ruby cycle count." do
      custom_message = default_message
      custom_message[:timestamp] = "#{(Time.now - 4000)}"
      instance = Factory(:instance, :instance_id => 'i-abcd1234')
      get :set_status, :message => custom_message.to_json
      instance.reload
      instance.ruby_cycle_count.should == 1
      response.body.should match /KILL/
    end
  end

  describe "GET set_status" do 
    it "send KILL response if ruby times out, but recycles node when cycle count > MAX." do
      custom_message = default_message
      custom_message[:timestamp] = "#{Time.now - 4000}"
      instance = Factory(:instance, :instance_id => 'i-abcd1234', :ruby_cycle_count => (RUBY_CYCLE_MAX + 1))
      get :set_status, :message => custom_message.to_json
      Delayed::Job.reserve_and_run_one_job
      instance.reload
      instance.instance_id.should_not == 'i-abcd1234'
      instance.ruby_cycle_count.should == 0
      instance.terminate #clean up
      sleep 3
    end
  end
  
  describe "GET set_status" do 
    it "send KILL response if ruby times out, but not when cycle count > MAX. should shut down a node that exceeds MAX CYCLE" do
      custom_message = default_message
      custom_message[:timestamp] = "#{Time.now - 4000}"
      instance = Factory(:instance, :instance_id => 'i-abcd1234', :cycle_count => (NODE_CYCLE_MAX + 1), :ruby_cycle_count => (RUBY_CYCLE_MAX + 1))
      get :set_status, :message => custom_message.to_json
      Delayed::Job.reserve_and_run_one_job
      instance.reload
      instance.state.should == 'shutdown'

    end
  end
  

end
