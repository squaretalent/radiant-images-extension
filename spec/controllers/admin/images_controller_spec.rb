require 'spec_helper'

describe Admin::ImagesController do
  dataset :users
  dataset :images
  
  before :all do
    @image = images(:first)
    @images = Image.all
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
      
      it 'should use pagination' do
        get :index
        assigns(:images).class.should == WillPaginate::Collection
      end
    
    end  
    
    context 'search action' do
      
      before :each do
        login_as :admin
        stub(AWS::S3::Base).establish_connection!
      end
      
      it 'should render the search template on search action' do
        get :search
        response.should render_template(:search)
      end
      
      it 'should return valid search results'
      
      it 'should respond to JS requests correctly'
      
      it 'should respond to xml requests correctly'
      
      it 'should respond to json requests correctly'
            
    end
    
  end
    
  
end