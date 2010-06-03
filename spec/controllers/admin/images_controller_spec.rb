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
  
  describe "index" do    
    
    context "user not logged in" do

      before :each do 
        get :index
      end

      it "should redirect to login path" do
        response.should redirect_to(login_path)
      end

    end
    
    context "user logged in" do
    
      before :each do
        login_as :admin
        get :index
      end
      
      it "should render successfully" do
        response.should be_success
      end
      
      it "should have a list of images" do
        assigns(:images).should == @images
      end
      
    end
    
  end
  
end