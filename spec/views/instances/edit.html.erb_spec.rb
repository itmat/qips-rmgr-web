require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/instances/edit.html.erb" do
  include InstancesHelper

  before(:each) do
    assigns[:instance] = @instance = stub_model(Instance,
      :new_record? => false
    )
  end

  it "renders the edit instance form" do
    render

    response.should have_tag("form[action=#{instance_path(@instance)}][method=post]") do
    end
  end
end
