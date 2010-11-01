require 'spec_helper'

describe Images::Tags::Core do
  
  dataset :pages, :images
    
  before(:all) do
    @images = [ images(:first), images(:second), images(:third),
                images(:fourth), images(:fifth), images(:sixth) ]
  end
  
  before(:each) do
    stub(AWS::S3::Base).establish_connection!
  end
  
  describe '<r:images>' do
    
    it 'should render its contents' do
      input    = '<r:images>success</r:images>'
      expected = 'success'
      pages(:home).should render(input).as(expected)
    end
    
    it 'should add the images namespace to nested radius tags' do
      input = '<r:images><r:if_images>success</r:if_images></r:images>'
      pages(:home).should render(input)
    end
    
  end
  
  describe '<r:images:if_images>' do
    
    it 'should render its contents when there are images' do
      input    = '<r:images><r:if_images>success</r:if_images></r:images>'
      expected = 'success'
      pages(:home).should render(input).as(expected)
    end
      
    it 'should not render its contents when there are no images' do
      mock(Image).all { [] }
      input    = '<r:images><r:if_images>failure</r:if_images></r:images>'
      expected = ''
      pages(:home).should render(input).as(expected)
    end
      
  end
  
  describe '<r:images:unless_images>' do
      
    it 'should render its contents when there are no images' do
      mock(Image).all { [] }
      input    = '<r:images><r:unless_images>success</r:unless_images></r:images>'
      expected = 'success'
      pages(:home).should render(input).as(expected)
    end
      
    it 'should not render its contents when there are images' do
      input    = '<r:images><r:unless_images>failure</r:unless_images></r:images>'
      expected = ''
      pages(:home).should render(input).as(expected)
    end
    
  end
  
  describe '<r:images:each>' do
    
    it 'should expand its contents once for each of the available images'
    
    it 'should not expand its contents if there are no images available'
    
    it 'should limit the number of images based on the limit parameter passed'
    
    it 'should use the offset parameter to ignore results before the offset'
    
    it 'should order the results based by the key passed'
    
    it 'should order the results by ascending order when asc is passed for the order'
    
    it 'should order the results by descending order when desc is passed for the order'
    
  end
  
  describe '<r:image>' do
    
    it 'should add the image namespace to nested radius tags'
    
    it 'should allow images to be looked up by their id attribute'
    
    it 'should allow images to be looked up by their position attribute'
        
    it 'should allow images to be looked up by their title attribute'
    
    it 'should render its contents if there is a current image'
    
    it 'should not render its contents if there is no current image'
    
  end

  describe '<r:image:url>' do
    
    it 'should render a valid url given a valid image context'
    
    it 'should not render a valid url if there is no current image'
    
    it 'should render the url with the default style if not specified'
    
    it 'should render the url with the style specified by the user'
    
  end
  
  describe '<r:image:tag>' do
    
    it 'should render a valid img tag given a valid image context'
    
    it 'should not render a valid img tag if there is no current image'
    
    it 'should render the img tag with the default style if not specified'
    
    it 'should render the img tag with the style specified by the user'
    
  end
  
  describe '<r:id>' do
    
    it 'should render the id of the current image context'
    
    it 'should not render anything if there is no current image context'
    
  end
  
  describe '<r:title>' do
    
    it 'should render the title of the current image context'
    
    it 'should not render anything if there is no current image context'
    
  end
  
  describe '<r:position>' do
    
    it 'should render the position of the current image context'
    
    it 'should not render anything if there is no current image context'
    
  end
  
end