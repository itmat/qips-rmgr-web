require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/roles/index.html.erb" do
  include RolesHelper

  before(:each) do
    assigns[:roles] = [
      stub_model(Role),
      stub_model(Role)
    ]
  end

  it "renders a list of roles" do
    render
  end
end
