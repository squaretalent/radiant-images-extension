require 'spec_helper'

describe Images::Tags::Core do
  dataset :pages, :images
  
  it 'should describe these tags' do
    pending 'some tags still need to be completed before this check will pass!'
    Images::Tags::Core.tags.sort.should == [
      'images',
      'images:if_images',
      'images:unless_images',
      'images:each',
      'image',
      'image:url',
      'image:id',
      'image:title'].sort
  end
  
  before(:all) do
    @images = [ images(:first), images(:second) ]
  end
  
  before(:each) do
    stub(AWS::S3::Base).establish_connection!
  end
  
  describe '<r:images>' do
    
    it 'should render' do
      tag = '<r:images>success</r:images>'
      exp = 'success'
      
      pages(:home).should render(tag).as(exp)
    end
    
  end
  
  describe '<r:images:if_images>' do
    
    context 'success' do
      it 'should render' do
        tag = '<r:images><r:if_images>success</r:if_images></r:images>'
        exp = 'success'
        
        pages(:home).should render(tag).as(exp)
      end
      it 'should render' do
        tag = '<r:images key="title" value="first"><r:if_images>success</r:if_images></r:images>'
        exp = 'success'
        
        pages(:home).should render(tag).as(exp)
      end
    end
    
    context 'failure' do
      it 'should not render' do
        mock(Image).all { [] }
        tag = '<r:images><r:if_images>failure</r:if_images></r:images>'
        exp = ''
        
        pages(:home).should render(tag).as(exp)
      end
      it 'should not render' do
        tag = '<r:images key="title" value="notme"><r:if_images>failure</r:if_images></r:images>'
        exp = ''
        
        pages(:home).should render(tag).as(exp)
      end
    end
    
  end
  
  describe '<r:images:unless_images>' do
    
    context 'success' do
      it 'should render' do
        mock(Image).all { [] }
        tag = '<r:images><r:unless_images>success</r:unless_images></r:images>'
        exp = 'success'
        
        pages(:home).should render(tag).as(exp)
      end
      it 'should render' do
        tag = '<r:images key="title" value="notme"><r:unless_images>success</r:unless_images></r:images>'
        exp = 'success'
        
        pages(:home).should render(tag).as(exp)
      end
    end
    
    context 'failure' do
      it 'should not render' do
        tag = '<r:images><r:unless_images>failure</r:unless_images></r:images>'
        exp = ''
        
        pages(:home).should render(tag).as(exp)
      end
      it 'should not render' do
        tag = '<r:images key="title" value="first"><r:unless_images>failure</r:unless_images></r:images>'
        exp = ''
        
        pages(:home).should render(tag).as(exp)
      end
    end
    
  end
  
end