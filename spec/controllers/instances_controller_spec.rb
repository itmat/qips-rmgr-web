require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InstancesController do

  def mock_instance(stubs={})
    @mock_instance ||= mock_model(Instance, stubs)
  end

  describe "GET index" do
    it "assigns all instances as @instances" do
      Instance.stub!(:find).with(:all).and_return([mock_instance])
      get :index
      assigns[:instances].should == [mock_instance]
    end
  end

  describe "GET show" do
    it "assigns the requested instance as @instance" do
      Instance.stub!(:find).with("37").and_return(mock_instance)
      get :show, :id => "37"
      assigns[:instance].should equal(mock_instance)
    end
  end

  describe "GET new" do
    it "assigns a new instance as @instance" do
      Instance.stub!(:new).and_return(mock_instance)
      get :new
      assigns[:instance].should equal(mock_instance)
    end
  end

  describe "GET edit" do
    it "assigns the requested instance as @instance" do
      Instance.stub!(:find).with("37").and_return(mock_instance)
      get :edit, :id => "37"
      assigns[:instance].should equal(mock_instance)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created instance as @instance" do
        Instance.stub!(:new).with({'these' => 'params'}).and_return(mock_instance(:save => true))
        post :create, :instance => {:these => 'params'}
        assigns[:instance].should equal(mock_instance)
      end

      it "redirects to the created instance" do
        Instance.stub!(:new).and_return(mock_instance(:save => true))
        post :create, :instance => {}
        response.should redirect_to(instance_url(mock_instance))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved instance as @instance" do
        Instance.stub!(:new).with({'these' => 'params'}).and_return(mock_instance(:save => false))
        post :create, :instance => {:these => 'params'}
        assigns[:instance].should equal(mock_instance)
      end

      it "re-renders the 'new' template" do
        Instance.stub!(:new).and_return(mock_instance(:save => false))
        post :create, :instance => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested instance" do
        Instance.should_receive(:find).with("37").and_return(mock_instance)
        mock_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :instance => {:these => 'params'}
      end

      it "assigns the requested instance as @instance" do
        Instance.stub!(:find).and_return(mock_instance(:update_attributes => true))
        put :update, :id => "1"
        assigns[:instance].should equal(mock_instance)
      end

      it "redirects to the instance" do
        Instance.stub!(:find).and_return(mock_instance(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(instance_url(mock_instance))
      end
    end

    describe "with invalid params" do
      it "updates the requested instance" do
        Instance.should_receive(:find).with("37").and_return(mock_instance)
        mock_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :instance => {:these => 'params'}
      end

      it "assigns the instance as @instance" do
        Instance.stub!(:find).and_return(mock_instance(:update_attributes => false))
        put :update, :id => "1"
        assigns[:instance].should equal(mock_instance)
      end

      it "re-renders the 'edit' template" do
        Instance.stub!(:find).and_return(mock_instance(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested instance" do
      Instance.should_receive(:find).with("37").and_return(mock_instance)
      mock_instance.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the instances list" do
      Instance.stub!(:find).and_return(mock_instance(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(instances_url)
    end
  end

end
