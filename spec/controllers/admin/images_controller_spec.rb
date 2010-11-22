require 'spec_helper'

describe Admin::ImagesController do
  
  dataset :users
  dataset :images
  
  before :all do
    @image = images(:first)
    @images = Image.all
  end
  
  context 'index action' do
    
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

      it 'should render the index template on index action' do
        get :index
        response.should render_template(:index)
      end

      it 'should have a list of images' do
        get :index
        assigns(:images).should == @images
      end

      it 'should use pagination' do
        get :index
        assigns(:images).class.should == WillPaginate::Collection
      end
      
      it 'should include the index stylesheet' do
        mock(controller).index_assets
        get :index
      end

    end
        
  end
    
  context 'edit action' do
  
    context 'user logged in' do

      before :each do
        login_as :admin
        stub(AWS::S3::Base).establish_connection!
      end
      
      it 'should include the edit stylesheet' do
        mock(controller).edit_assets
        get :edit, :id => @image.id
      end
    
    end  
    
  end
  
  context 'show action' do
  
    context 'user logged in' do

      before :each do
        login_as :admin
        stub(AWS::S3::Base).establish_connection!
      end
      
      it 'should include the edit stylesheet' do
        mock(controller).edit_assets
        get :show, :id => @image.id
      end
    
    end  
    
  end
  
  context 'rescusing S3 exceptions' do
    
    before :each do
      controller = Admin::ImagesController.new
    end
    
    it 'should catch any AWS S3 response errors thrown' do
      stub(controller).redirect_to(anything)
      controller.send :rescue_s3_exceptions do
        raise AWS::S3::ResponseError.new('error name', '')
      end
    end
    
    it 'should set the flash message' do
      stub(controller).redirect_to(anything)
      controller.send :rescue_s3_exceptions do
        raise AWS::S3::ResponseError.new('some error' ,'')
      end
      flash.now[:error].should == 'some error'
      
    end
    
    it 'should redirect to the admin images url' do
      mock(controller).redirect_to(admin_images_url)
      controller.send :rescue_s3_exceptions do
        raise AWS::S3::ResponseError.new('error' ,'')
      end
    end
    
    it 'should not catch any other errors thrown' do
      lambda { controller.send :rescue_s3_exceptions do
        raise 'another type of error'
      end }.should raise_error 'another type of error'
    end
    
  end
    
end
