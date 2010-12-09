require File.dirname(__FILE__) + "/../spec_helper"

describe Attachment do
  
  dataset :attachments
  
  context 'attributes' do
  
    before(:each) do
      @attachment = attachments(:first)
    end
      
    it 'should have a position' do
      @attachment.position.should === 1
    end
    
    it 'should have a product' do
      @attachment.page.class.should == Page
    end
    
    it 'should have an image' do
      @attachment.image.class.should == Image
    end
    
  end
  
  context 'alias methods' do
    
    before(:each) do
      stub(AWS::S3::Base).establish_connection!
      @attachment = attachments(:first)
    end
    
    describe '#url' do
      it 'should return its assets url' do
        stub(@attachment).image.stub!.url { 'url' }
        @attachment.url.should === @attachment.image.url
      end
    end
    describe '#title' do
      it 'should return its assets title' do
        @attachment.title.should === @attachment.image.title
      end
    end
    describe '#caption' do
      it 'should return its assets caption' do
        @attachment.caption.should === @attachment.image.caption
      end
    end
  end
  
end
