require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FarmsController do

  def mock_farm(stubs={})
    @mock_farm ||= mock_model(Farm, stubs)
  end

  describe "GET index" do
    it "assigns all farms as @farms" do
      Farm.stub!(:find).with(:all).and_return([mock_farm])
      get :index
      assigns[:farms].should == [mock_farm]
    end
  end

  describe "GET show" do
    it "assigns the requested farm as @farm" do
      Farm.stub!(:find).with("37").and_return(mock_farm)
      get :show, :id => "37"
      assigns[:farm].should equal(mock_farm)
    end
  end

  describe "GET new" do
    it "assigns a new farm as @farm" do
      Farm.stub!(:new).and_return(mock_farm)
      get :new
      assigns[:farm].should equal(mock_farm)
    end
  end

  describe "GET edit" do
    it "assigns the requested farm as @farm" do
      Farm.stub!(:find).with("37").and_return(mock_farm)
      get :edit, :id => "37"
      assigns[:farm].should equal(mock_farm)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created farm as @farm" do
        Farm.stub!(:new).with({'these' => 'params'}).and_return(mock_farm(:save => true))
        post :create, :farm => {:these => 'params'}
        assigns[:farm].should equal(mock_farm)
      end

      it "redirects to the created farm" do
        Farm.stub!(:new).and_return(mock_farm(:save => true))
        post :create, :farm => {}
        response.should redirect_to(farm_url(mock_farm))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved farm as @farm" do
        Farm.stub!(:new).with({'these' => 'params'}).and_return(mock_farm(:save => false))
        post :create, :farm => {:these => 'params'}
        assigns[:farm].should equal(mock_farm)
      end

      it "re-renders the 'new' template" do
        Farm.stub!(:new).and_return(mock_farm(:save => false))
        post :create, :farm => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested farm" do
        Farm.should_receive(:find).with("37").and_return(mock_farm)
        mock_farm.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :farm => {:these => 'params'}
      end

      it "assigns the requested farm as @farm" do
        Farm.stub!(:find).and_return(mock_farm(:update_attributes => true))
        put :update, :id => "1"
        assigns[:farm].should equal(mock_farm)
      end

      it "redirects to the farm" do
        Farm.stub!(:find).and_return(mock_farm(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(farm_url(mock_farm))
      end
    end

    describe "with invalid params" do
      it "updates the requested farm" do
        Farm.should_receive(:find).with("37").and_return(mock_farm)
        mock_farm.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :farm => {:these => 'params'}
      end

      it "assigns the farm as @farm" do
        Farm.stub!(:find).and_return(mock_farm(:update_attributes => false))
        put :update, :id => "1"
        assigns[:farm].should equal(mock_farm)
      end

      it "re-renders the 'edit' template" do
        Farm.stub!(:find).and_return(mock_farm(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested farm" do
      Farm.should_receive(:find).with("37").and_return(mock_farm)
      mock_farm.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the farms list" do
      Farm.stub!(:find).and_return(mock_farm(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(farms_url)
    end
  end

end
