require File.dirname(__FILE__) + '/../spec_helper'

describe ImagesController do
  
  describe "show" do
    
    context "image exists" do
      
      before :each do
        stub(Image).find(anything) { Image.new() }
        stub.instance_of(Image).url { '/test/image/url' }
      end
      
      it "should render image" do
        get :show, :id => 1, :style => 'normal'
        
        flash.now[:notice].should be_nil
        response.body.include?('/test/image/url')
      end
    end
    
    context "image doesn't exist" do
      
      before :each do        
        mock(Image).find(anything) { raise ActiveRecord::RecordNotFound }
      end
      
      it "should render cant find" do
        get :show, :id => 1, :style => 'normal'
      
        flash.now[:notice].should == "Image could not be found."
        response.body.include?(Radiant::Config['images.missing'].to_s.gsub(':style', 'normal'))
      end
    end
  end
  
end