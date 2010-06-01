require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::ImagesController do
  dataset :users
  
  describe "index" do    
    it "should only be accessible by logged in users" do
      get :index
      
      response.should redirect_to(login_path)
    end
    
    it "should render successfully" do
      login_as :admin
      get :index
      
      response.should be_success
    end
  end
  
end