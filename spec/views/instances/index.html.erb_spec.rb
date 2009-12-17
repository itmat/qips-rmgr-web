require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/instances/index.html.erb" do
  include InstancesHelper

  before(:each) do
    assigns[:instances] = [
      stub_model(Instance),
      stub_model(Instance)
    ]
  end

  it "renders a list of instances" do
    render
  end
end
