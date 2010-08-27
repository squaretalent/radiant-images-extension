require File.dirname(__FILE__) + '/../spec_helper'

describe Image do
  dataset :images
  
  before(:each) do
    stub(AWS::S3::Base).establish_connection!
    @image = images(:first)
  end
  
  it 'should have a title' do
    @image.title.should == 'first'
  end
  
  context 's3 assets' do
    it 'should have an asset' do
      @image.asset.class.should == Paperclip::Attachment
    end
    
    it 'should have a file_name' do
      @image.asset_file_name.should == 'first.png'
    end
    
    it 'should have a file_type' do
      @image.asset_content_type.should == 'image/png'
    end
    
    it 'should have a file_size' do
      @image.asset_file_size.should == "1000"
    end
    
    it 'should have filters' do
 
    end
  end

  
end