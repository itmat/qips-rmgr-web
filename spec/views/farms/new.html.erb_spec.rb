require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/farms/new.html.erb" do
  include FarmsHelper

  before(:each) do
    assigns[:farm] = stub_model(Farm,
      :new_record? => true
    )
  end

  it "renders new farm form" do
    render

    response.should have_tag("form[action=?][method=post]", farms_path) do
    end
  end
end
