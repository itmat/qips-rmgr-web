require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/instances/new.html.erb" do
  include InstancesHelper

  before(:each) do
    assigns[:instance] = stub_model(Instance,
      :new_record? => true
    )
  end

  it "renders new instance form" do
    render

    response.should have_tag("form[action=?][method=post]", instances_path) do
    end
  end
end
