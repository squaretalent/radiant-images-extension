require File.dirname(__FILE__) + '/../../spec_helper'

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
    
    it 'should only run through however many images we specify with limit' do
      content = '<r:images:each limit="2"><r:images:url/></r:images:each>'
      expected = ''
      @images[0..1].each { |image| expected += image.url }
      pages(:home).should render(content).as(expected)
    end
    
    it 'should start at the image number we give it using offset' do
      content = '<r:images:each limit="2" offset="1"><r:images:url/></r:images:each>'
      expected = ''
      @images[1..2].each { |image| expected += image.url }
      pages(:home).should render(content).as(expected)
    end
    
    it 'should display images in the order we give' do
      # asc
      content = '<r:images:each order="asc" by="position"><r:images:url/></r:images:each>'
      expected = ''
      @images.each { |image| expected += image.url }
      pages(:home).should render(content).as(expected)
      
      #desc
      content = '<r:images:each order="desc" by="position"><r:images:url/></r:images:each>'
      expected = ''
      @images.reverse.each { |image| expected += image.url }
      pages(:home).should render(content).as(expected)
    end
    
    it 'should allow us to order images by title' do
      content = '<r:images:each order="asc" by="title"><r:images:url/></r:images:each>'
      expected = ''
      @images.sort! { |a,b| a.title <=> b.title }
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