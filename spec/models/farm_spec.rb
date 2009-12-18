require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Farm do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    Farm.create!(@valid_attributes)
  end
  
  it "should strip whitespace form security groups on save" do
    Farm.create!(@valid_attributes) #PLACEHOLDER
  end
  
  it "should scale down instance that have been idle for a while" do
    Farm.create!(@valid_attributes) #PLACEHOLDER
  end
  
  it "should not scale down instances that have been idle for a while and are busy" do
    Farm.create!(@valid_attributes) #PLACEHOLDER
  end
  
  it "should not scale down instances that have not been idle for a while" do
    Farm.create!(@valid_attributes) #PLACEHOLDER
  end
  
  it "should start up instances during reconcile that are below minimum" do
    Farm.create!(@valid_attributes) #PLACEHOLDER
  end
  
  it "should shut down instances during reconcile that are above maximum" do
    Farm.create!(@valid_attributes) #PLACEHOLDER
  end

  it "should NOT shut down instances during reconcile that are above maximum and are not available" do
    Farm.create!(@valid_attributes) #PLACEHOLDER
  end
  
  
  
end
