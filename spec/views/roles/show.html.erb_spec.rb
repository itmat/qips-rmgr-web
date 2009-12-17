require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/roles/show.html.erb" do
  include RolesHelper
  before(:each) do
    assigns[:role] = @role = stub_model(Role)
  end

  it "renders attributes in <p>" do
    render
  end
end
