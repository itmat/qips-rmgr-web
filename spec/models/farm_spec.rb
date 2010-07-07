require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Farm do
  before(:each) do
    # do not have to create farms and roles here because the instance factory should create them all at run time    
    # FARM FACTORY MUST HAVE LIVE AMI ID
    
    @valid_attributes = {
      
    }
  end
  
  it "should strip whitespace form security groups on save" do
    farm = Factory(:farm)
    farm.security_groups = "   test one, test two  "
    farm.save
    farm.security_groups.should == "testone,testtwo"
    farm.destroy # cleanup
  end
  
  it "should scale down instance that have been idle for a while" do
    instance = Factory(:instance)
    instance.recycle # workaround to start instance in aws
    Delayed::Worker.new.work_off
    instance.state = "idle"
    instance.launch_time = (Time.now - 3300) # sets launch time for 54 mins ago
    instance.save
    instance.running?.should == true
    instance.reload
    instance.farm.scale_down.should == 1
    instance.reload
    instance.running?.should == false
    sleep 3
  end
  
  it "should NOT scale down instances that have been idle for a while and are busy" do
    instance = Factory(:instance)
    instance.recycle # workaround to start instance in aws
    Delayed::Worker.new.work_off
    instance.state = "busy"
    instance.launch_time = (Time.now - 3300) # sets launch time for 54 mins ago
    instance.save
    instance.running?.should == true
    instance.reload
    instance.farm.scale_down.should == 0
    instance.reload
    instance.running?.should == true
    instance.terminate # cleanup
    sleep 3
    
  end
  
  it "should NOT scale down instances that have NOT been idle for a while" do
    instance = Factory(:instance)
    instance.recycle # workaround to start instance in aws
    Delayed::Worker.new.work_off
    instance.state = "idle"
    instance.launch_time = (Time.now - 300) # sets launch time for 5 mins ago
    instance.save
    instance.running?.should == true
    instance.reload
    instance.farm.scale_down.should == 0
    instance.reload
    instance.running?.should == true
    instance.terminate # cleanup
    sleep 3
    
  end
  
  it "should start up instances during reconcile that are below minimum" do
    Instance.destroy_all
    farm = Factory(:farm, :min => 1)
    farm.instances.size.should == 0
    farm.reconcile
    Delayed::Worker.new.work_off
    sleep 5
    farm.reload
    farm.instances.size.should == 1
    farm.instances.each {|i| i.terminate } # cleanup!
    sleep 3
    
  end
  
  it "should shut down instances during reconcile that are above maximum" do
    Instance.destroy_all
    farm = Factory(:farm, :min => 0, :max => 1)
    farm.instances.size.should == 0
    instance1 = Factory(:instance, :farm => farm)
    instance2 = Factory(:instance, :farm => farm)
    # have to recycle instances so they are real, otherwise reconcile sync will delete all of them
    instance1.recycle
    Delayed::Worker.new.work_off
    instance2.recycle
    Delayed::Worker.new.work_off
    farm.reload
    farm.reconcile
    sleep 5
    farm.reload
    farm.instances.select{|i| i.running? }.size.should == 1
    farm.instances.each {|i| i.terminate } # cleanup!
    sleep 3
    
  end

  it "should NOT shut down instances during reconcile that are above maximum and are not available" do
    Instance.destroy_all
    farm = Factory(:farm, :min => 0, :max => 1)
    farm.instances.size.should == 0
    instance1 = Factory(:instance, :farm => farm)
    instance2 = Factory(:instance, :farm => farm)
    # have to recycle instances so they are real, otherwise reconcile will delete all of them
    instance1.recycle
    Delayed::Worker.new.work_off
    instance2.recycle
    Delayed::Worker.new.work_off
    instance1.update_attribute("state", "busy")
    instance2.update_attribute("state", "busy")
    farm.reload
    farm.reconcile
    sleep 5
    farm.reload
    farm.instances.select{|i| i.running? }.size.should == 2
    farm.instances.each {|i| i.terminate } # cleanup!
    sleep 3
    
  end
  
  
  
end
