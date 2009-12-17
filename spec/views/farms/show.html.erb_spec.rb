require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/farms/show.html.erb" do
  include FarmsHelper
  before(:each) do
    assigns[:farm] = @farm = stub_model(Farm)
  end

  it "renders attributes in <p>" do
    render
  end
end
