require File.dirname(__FILE__) + '/../spec_helper'

describe ImagesController do
  
  describe "show" do
    
    context "image exists" do
      
      before :each do
        mock(Image).find.with(anything) { Image.new() }
        stub(Image).asset_content_type { true }
        stub(Image).asset_file_name { true }
        stub(Image).asset_file_size { true }
      end
      
      it "should render image" do
        get :show, :id => 1
        
        flash.now[:notice].should be_nil
        response.should be_success
      end
    end
    
    context "image doesn't exist" do
      it "should render cant find" do
        mock(Image).find.with(anything) { raise ActiveRecord::RecordNotFound }
      
        get :show, :id => 1
      
        flash.now[:notice].should == "Could not find image."
        response.should_not be_success
      end
    end
  end
  
end