require File.dirname(__FILE__) + '/../spec_helper'

describe Image do
  dataset :images
  
  before(:each) do
    @image = images(:first)
    @images = [
      images(:first),
      images(:second)
    ]
  end
  
  context 'attributes' do
    
    it 'should have a title' do
      @image.title.should == 'first'
    end
    
    it 'should have a caption' do
      @image.caption.should == 'caption for first'
    end
    
    it 'should have a file_name' do
      @image.asset_file_name.should == 'first.png'
    end
    
    it 'should have a content/type' do
      @image.asset_content_type.should == 'image/png'
    end
    
    it 'should have a file_size' do
      @image.asset_file_size.should == "1000"
    end
    
    it 'should have a position' do 
      @image.position.should == 1
    end
    
  end
  
  context 'paperclip' do
    
    it 'should have the configs defined, even if paperclip wont load them' do
      Radiant::Config['images.missing'].should_not be_nil
      Radiant::Config['s3.key'].should_not be_nil
      Radiant::Config['s3.secret'].should_not be_nil
      Radiant::Config['s3.bucket'].should_not be_nil
      Radiant::Config['s3.path'].should_not be_nil
    end
    
    it 'should have an asset' do
      @image.asset.class.inspect
    end
    
    it 'should have built styles from config string' do
      Radiant::Config['images.styles'].include?(":#{Image.config_styles.first[0]}")
    end
    
    it 'should generate a url based on its asset' do
      @image.url.should == @image.asset.url
    end
    
  end
  
  context '#search' do
    
    it "should return all results if nothing is passed" do
      @result = Image.search
      @result.class.should == WillPaginate::Collection
      @result.length.should == @images.length
      @result.should == @images
    end
    
    it "should return a subset if a title is passed" do
      @result = Image.search(@image.title)
      @result.class.should == WillPaginate::Collection
      @result.include?(@image)
      @result.length.should == 1
    end
    
    it "should return a subset if a caption is passed" do
      @result = Image.search(@image.caption)
      @result.class.should == WillPaginate::Collection
      @result.include?(@image)
      @result.length.should == 1
    end
    
    it "should return a subset if a filename is passed" do
      @result = Image.search(@image.asset_file_name)
      @result.class.should == WillPaginate::Collection
      @result.include?(@image)
      @result.length.should == 1
    end
    
    it "should return an empty array if a non-existent value is passed" do
      @result = Image.search('iwontexist')
      @result.class.should == WillPaginate::Collection
      @result.length.should == 0
    end
    
  end
  
end