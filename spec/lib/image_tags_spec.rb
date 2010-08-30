require File.dirname(__FILE__) + '/../spec_helper'

describe Images::ImageTags do
  dataset :pages
  
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
  
  
  
end