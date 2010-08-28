require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::ImagesController do
  dataset :users
  dataset :images
  
  before :all do
    @image = images(:first)
    @images = [
      images(:first),
      images(:second)
    ]
  end
   
    
  context 'user not logged in' do

    it 'should redirect to login path' do
      get :index
      response.should redirect_to login_path
    end

  end
  
  context 'user logged in' do
  
    before :each do
      login_as :admin
      stub(AWS::S3::Base).establish_connection!
    end
    
    context 'index action' do
    
      it 'should render the index template on index action' do
        get :index
        response.should render_template(:index)
      end
      
      it 'should have a list of images' do
        get :index
        assigns(:images).should == @images
      end
    
    end
    
    context 'show action' do
      
      it 'should redirect to the edit action' do
        get :show, :id => @image.id
        response.should redirect_to edit_admin_image_url(@image)
      end
      
    end
    
    context 'edit action' do
      
      it 'should render the edit template' do
        get :edit, :id => @image.id
        response.should render_template(:edit)
      end
      
      it 'should redirect to the index on invalid image id' do
        get :edit, :id => 999999
        response.should redirect_to admin_images_url
      end
      
    end
    
    context 'new action' do
      
      it 'should render the new template' do
        get :new
        response.should render_template(:new)
      end
      
    end
    
    context 'update action' do
      
      it 'should redirect to the index on valid image' do
        put :update, :id => @image.id
        response.should redirect_to admin_images_url
      end
      
      it 'should render the edit template on invalid model' do
        any_instance_of(Image, :valid? => false)
        put :update, :id => @image.id
        response.should render_template(:edit)
      end
      
    end
    
    context 'create action' do
      
      it "create action should render new template when model is invalid" do
        stub.instance_of(Image).valid? {false}
        post :create
        response.should render_template(:new)
      end

      it "create action should redirect when model is valid" do
        stub.instance_of(Image).valid? {true}
        post :create
        response.should redirect_to admin_images_url
      end
      
      
    end
    
    context 'remove action' do
      
      it 'should render the remove template' do
        get :remove, :id => @image.id
        response.should render_template(:remove)
        
      end
      
    end
    
    context 'destroy action' do
      
      it 'should redirect to the index' do
        # we need to stop destroy_attached_files running (as it'll error with no S3 details)
        mock(@images[1]).destroy_attached_files
        
        @images[1].destroy
        delete :destroy, :id => @images[1].id
        response.should redirect_to admin_images_url
        Image.exists?(@images[1].id).should be_false
      end
      
    end
  
    
  end
    
  
end