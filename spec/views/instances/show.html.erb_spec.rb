require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/instances/show.html.erb" do
  include InstancesHelper
  before(:each) do
    assigns[:instance] = @instance = stub_model(Instance)
  end

  it "renders attributes in <p>" do
    render
  end
end
