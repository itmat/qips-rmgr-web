require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/farms/edit.html.erb" do
  include FarmsHelper

  before(:each) do
    assigns[:farm] = @farm = stub_model(Farm,
      :new_record? => false
    )
  end

  it "renders the edit farm form" do
    render

    response.should have_tag("form[action=#{farm_path(@farm)}][method=post]") do
    end
  end
end
