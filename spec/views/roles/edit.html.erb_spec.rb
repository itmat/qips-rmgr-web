require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/roles/edit.html.erb" do
  include RolesHelper

  before(:each) do
    assigns[:role] = @role = stub_model(Role,
      :new_record? => false
    )
  end

  it "renders the edit role form" do
    render

    response.should have_tag("form[action=#{role_path(@role)}][method=post]") do
    end
  end
end
