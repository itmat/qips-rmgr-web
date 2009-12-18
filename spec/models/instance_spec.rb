require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Instance do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    Instance.create!(@valid_attributes)
  end
  
  it "should increment cycle count when recycling and instance" do
    Instance.create!(@valid_attributes)  #PLACEHOLDER
  end
  
  it "should reset all the vars when recycled" do
    Instance.create!(@valid_attributes) #PLACEHOLDER
  end
    
  it "should accurately indicate when an instance is running" do
    Instance.create!(@valid_attributes) #PLACEHOLDER
  end
        
  it "should accurately indicate when an instance is availble " do
    Instance.create!(@valid_attributes) #PLACEHOLDER
  end
  
  it "should show whether or not a node has been silent for a certain amount of time" do
    Instance.create!(@valid_attributes) #PLACEHOLDER
  end
    
end
