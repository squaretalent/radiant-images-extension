require 'spec_helper'

describe Image do
  dataset :images
  
  before(:each) do
    stub(AWS::S3::Base).establish_connection!
    @image = images(:first)
  end
  
  it 'should have a title' do
    @image.title.should == 'first'
  end
  
  it 'should have a caption' do
    @image.caption.should == "caption for #{@image.title.to_s}"
  end
  
  it 'should require a unique title' do
    @new_image = @image.clone
    @new_image.valid?
    @new_image.errors.on(:title).should include 'name is already in use'
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
    
    it 'should require a valid asset' do
      # create an invalid image without an asset!
      image = Image.new
      image.valid?
      image.errors.on(:asset).should include 'must be set'
    end
    
    it 'should require a unique filename' do
      @new_image = @image.clone
      @new_image.valid?
      @new_image.errors.on(:asset_file_name).should include 'file already exists'
    end
    
    it 'should only allow image content types' do
      @image.asset_content_type = 'not/image'
      @image.valid?
      @image.errors.on(:asset).should include 'not one of the allowed file types'
    end
    

  end

  
end