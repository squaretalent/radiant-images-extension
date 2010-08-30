require File.dirname(__FILE__) + '/../spec_helper'

describe Images::ImageTags do
  dataset :pages
  dataset :images
  
  before(:all) do
    @images = Image.all
  end
  
  describe '<r:images>' do
    
    it 'should render without errors' do
      content = '<r:images></r:images>'
      pages(:home).should render(content)
    end
    
    it 'should allow tags in the images namespace to be used without defining their namespace' do
      content = '<r:images><r:each></r:each></r:images>'
      pages(:home).should render(content)
    end
    
  end
  
  describe '<r:images:each>' do
    
    it 'should run through all of our images' do
      content = '<r:images:each>hi!</r:images:each>'
      expected = ''
      @images.length.times { expected += 'hi!' }
      pages(:home).should render(content).as(expected)
    end
    
    it 'should be running through the image objects' do
      content = '<r:images:each><r:images:url/></r:images:each>'
      expected = ''
      @images.each { |image| expected += image.asset_file_name }
      pages(:home).should render(content).as(expected)
    end
        
  end
  
  
  
end