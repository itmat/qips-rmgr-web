require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/farms/index.html.erb" do
  include FarmsHelper

  before(:each) do
    assigns[:farms] = [
      stub_model(Farm),
      stub_model(Farm)
    ]
  end

  it "renders a list of farms" do
    render
  end
end
