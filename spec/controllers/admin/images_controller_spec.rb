require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::ImagesController do
  dataset :users
  dataset :images
  
  before :each do
    @image = images(:first)
    @images = [
      images(:first),
      images(:second)
    ]
  end
  
  describe "#index" do    
    
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
  
  describe "#show" do 
    
    context "user not logged in" do

      before :each do 
        get :show, :id => 1
      end

      it "should redirect to login path" do
        response.should redirect_to(login_path)
      end

    end
    
    context "user logged in" do
    
      before :each do
        login_as :admin
      end
    
      context "image does not exist" do
    
        before :each do
          get :show, :id => 0
        end
      
        it "should redirect to edit" do
          response.should be_redirect
        end
    
      end
    
      context "image exists" do
      
        before :each do
          get :show, :id => @image.id
        end
      
        it "should redirect to edit" do
          response.should be_redirect
        end
      
      end
      
    end
    
  end
  
  describe "#edit" do
    
    context "user not logged in" do

      before :each do 
        get :show, :id => 1
      end

      it "should redirect to login path" do
        response.should redirect_to(login_path)
      end

    end
    
    context "user logged in" do
    
      before :each do
        login_as :admin
      end
    
      context "image does not exist" do
    
        before :each do
          get :edit, :id => 0
        end
      
        it "should redirect to index" do
          response.should redirect_to(admin_images_path)
        end
    
      end
    
      context "image exists" do
      
        before :each do
          get :edit, :id => @image.id
        end
      
        it "should render" do
          response.should be_success
        end
        
        it "should define the image" do
          assigns[:image].should == @image
        end
      
      end
      
    end
    
  end
  
end