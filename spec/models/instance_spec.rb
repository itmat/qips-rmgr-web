require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Instance do
  before(:all) do
    # do not have to create farms and roles here because the instance factory should create them all at run time    
    # FARM FACTORY MUST HAVE LIVE AMI ID
  end

  it "should increment cycle count when recycling an instance" do
    instance = Factory(:instance)
    instance.cycle_count.should == 0
    instance.recycle
    instance.cycle_count.should == 1
    instance.terminate #cleanup
    sleep 3
    
  end
  
  it "should reset all the vars when recycled" do
    instance = Factory(:instance)

    instance.ruby_cpu_usage = 1.1
    instance.system_cpu_usage = 2.2
    instance.ruby_mem_usage = 3
    instance.system_mem_usage = 4
    instance.top_pid = 5
    instance.ruby_pid_status = "six"
    instance.state_changed_at = Time.now
    instance.executable = "seven"
    instance.ruby_pid = 8
    instance.status_updated_at = Time.now
    instance.ruby_cycle_count = 9

    instance.recycle
    
    instance.ruby_cpu_usage.should be_nil
    instance.system_cpu_usage.should be_nil
    instance.ruby_mem_usage.should be_nil
    instance.system_mem_usage.should be_nil
    instance.top_pid.should be_nil
    instance.ruby_pid_status.should be_nil
    instance.state_changed_at.should be_nil
    instance.executable.should be_nil
    instance.ruby_pid.should be_nil
    instance.status_updated_at.should be_nil
    instance.ruby_cycle_count.should == 0
    
    instance.terminate #cleanup
    sleep 3
    
    
  end
    
  it "should accurately indicate when an instance is running" do
    instance = Factory(:instance)
    instance.state = "launched"
    instance.running?.should == true
    instance.state = "admin"
    instance.running?.should == true
    instance.state = "idle"
    instance.running?.should == true
    instance.state = "busy"
    instance.running?.should == true
    instance.state = "reserved"
    instance.running?.should == true
    instance.state = "manual"
    instance.running?.should == true
    instance.state = "shutdown"
    instance.running?.should == false
    instance.state = ""
    instance.running?.should == false
    
  end
        
  it "should accurately indicate when an instance is available " do
    instance = Factory(:instance)
    instance.state = "launched"
    instance.available?.should == true
    instance.state = "idle"
    instance.available?.should == true
    instance.state = "reserved"
    instance.available?.should == false
    instance.state = "busy"
    instance.available?.should == false
    instance.state = "admin"
    instance.available?.should == false
    instance.state = "manual"
    instance.available?.should == false
    instance.state = "shutdown"
    instance.available?.should == false
    instance.state = ""
    instance.available?.should == false
    
    
  end
  
  it "should show whether or not a node has been silent for a certain amount of time" do
    instance = Factory(:instance)
    instance.silent_since?(5).should == false
    instance.launch_time = (Time.now - 600)
    instance.silent_since?(5).should == true
    instance.status_updated_at = Time.now
    instance.silent_since?(5).should == false
    instance.status_updated_at = (Time.now-600)
    instance.silent_since?(5).should == true

   
  end
    
end
