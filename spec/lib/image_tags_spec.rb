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
    
    it 'should reference an image given its title' do
      image = @images[2]
      content = '<r:images title="' + image.title + '"><r:images:url /></r:images>'
      pages(:home).should render(content).as(image.url)
    end
    
    it 'should raise an exception if an image title is used that does not exist' do
      content = '<r:images title="doesntreallyexist"><r:images:url /></r:images>'
      lambda { pages(:home).render(content) }.should raise_error
    end
    
    
  end
  
  describe '<r:images:each>' do
    
    it 'should run through all of our images' do
      content = '<r:images:each>test!</r:images:each>'
      expected = ''
      @images.length.times { expected += 'test!' }
      pages(:home).should render(content).as(expected)
    end
    
    it 'should be running through the image objects' do
      content = '<r:images:each><r:images:url/></r:images:each>'
      expected = ''
      @images.each { |image| expected += image.url }
      pages(:home).should render(content).as(expected)
    end
        
  end
  
  describe '<r:images:first>' do
    
    it 'should render the first image' do
      content = '<r:images:first><r:images:url/></r:images:first>'
      expected = @images.first.url
      pages(:home).should render(content).as(expected)
    end
    
    
  end
  
  
  
end