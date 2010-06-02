require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::ImagesController do
  dataset :users
  
  describe "index" do    
    
    context "user not logged in" do

      it "should redirect to login path" do
        get :index

        response.should redirect_to(login_path)
      end

    end
    
    context "user logged in" do
    
      before :each do
        login_as :admin
      end
      
      it "should render successfully" do
        get :index

        response.should be_success
      end
      
    end
    
  end
  
end