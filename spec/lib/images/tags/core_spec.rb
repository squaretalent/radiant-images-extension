require File.dirname(__FILE__) + "/../../../spec_helper"

describe Images::Tags::Core do
  
  dataset :pages, :images
    
  before(:all) do
    @images = [ images(:first), images(:second), images(:third),
                images(:fourth), images(:fifth), images(:sixth) ]
    Radiant::Config['images.default'] = "original"
    Radiant::Config['images.path']    = ":rails_root/public/:class/:basename-:style.:extension"
    Radiant::Config['images.storage'] = "local"
    Radiant::Config['images.styles']  = "icon=45x45#,preview=200x200#,normal=640x640#"
    Radiant::Config['images.url']     = "/:class/:basename-:style.:extension"
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
    
    it 'should expand its contents once for each of the available images' do
      input    = '<r:images:each>test </r:images:each>'
      expected = 'test test test test test test '
      pages(:home).should render(input).as(expected)
    end
    
    it 'should not expand its contents if there are no images available' do
      mock(Image).all() { [] }
      mock(Image).all(anything) { [] }
      input    = '<r:images:each>test </r:images:each>'
      expected = ''
      pages(:home).should render(input).as(expected)
    end
    
    it 'should limit the number of images based on the limit parameter passed' do
      input    = '<r:images:each limit="3"><r:image:title /> </r:images:each>'
      expected = 'first second third '
      pages(:home).should render(input).as(expected)
    end
    
    it 'should use the offset parameter to ignore results before the offset' do
      input    = '<r:images:each limit="3" offset="2"><r:image:title /> </r:images:each>'
      expected = 'third fourth fifth '
      pages(:home).should render(input).as(expected)
    end
    
    it 'should order the results based by the key passed' do
      input    = '<r:images:each by="title"><r:image:title /> </r:images:each>'
      expected = 'fifth first fourth second sixth third '
      pages(:home).should render(input).as(expected)
    end
    
    it 'should order the results by ascending order when asc is passed for the order' do
      input    = '<r:images:each by="position" order="asc" ><r:image:title /> </r:images:each>'
      expected = 'first second third fourth fifth sixth '
      pages(:home).should render(input).as(expected)
    end
    
    it 'should order the results by descending order when desc is passed for the order' do
      input    = '<r:images:each by="position" order="desc" ><r:image:title /> </r:images:each>'
      expected = 'sixth fifth fourth third second first '
      pages(:home).should render(input).as(expected)
    end
    
  end
  
  describe '<r:image>' do
    
    it 'should add the image namespace to nested radius tags' do
      input    = '<r:image title="first"><r:title /></r:image>'
      expected = 'first'
      pages(:home).should render(input).as(expected)
    end
    
    it 'should render its contents if there is a current image' do
      input    = '<r:images:each><r:image title="first"><r:title /> </r:image></r:images:each>'
      expected = 'first second third fourth fifth sixth '
      pages(:home).should render(input).as(expected)
    end
    
    it 'should not render its contents if there is no current image' do
      input    = '<r:image title="invalid"><r:title /></r:image>'
      expected = ''
      pages(:home).should render(input).as(expected)
    end
    
    it 'should allow images to be looked up by their id attribute' do
      mock(Image).find('5') { @images[4] }
      input    = '<r:image id="5"><r:title /></r:image>'
      expected = 'fifth'
      pages(:home).should render(input).as(expected)
    end
    
    it 'should allow images to be looked up by their position attribute' do
      input    = '<r:image position="3"><r:title /></r:image>'
      expected = 'third'
      pages(:home).should render(input).as(expected)
    end
        
    it 'should allow images to be looked up by their title attribute' do
      input    = '<r:image title="sixth"><r:title /></r:image>'
      expected = 'sixth'
      pages(:home).should render(input).as(expected)
    end
    
  end

  describe '<r:image:url>' do
    
    before :each do
      asset = Paperclip::Attachment.new('asset', @images[0], { :url => Radiant::Config['images.url'] })
      stub(Image).find_by_title('first') { @images[0] }
      stub.proxy(Image).find_by_title('invalid')
      stub(@images[0]).asset { asset }
    end
            
    it 'should not render a valid url if there is no current image' do
      input    = '<r:image title="invalid"><r:url /></r:image>'
      expected = ''
      pages(:home).should render(input).as(expected)
    end
    
    it 'should render the url with the default style if not specified' do
      input    = '<r:image title="first"><r:url /></r:image>'
      expected = '/images/first-original.png'
      pages(:home).should render(input).as(expected)
    end
    
    it 'should render the url with the style specified by the user' do
      input    = '<r:image title="first"><r:url style="icon" /></r:image>'
      expected = '/images/first-icon.png'
      pages(:home).should render(input).as(expected)
    end
    
  end
  
  describe '<r:image:tag>' do
    
    before :each do
      asset = Paperclip::Attachment.new('asset', @images[0], { :url => Radiant::Config['images.url'] })
      stub(Image).find_by_title('first') { @images[0] }
      stub.proxy(Image).find_by_title('invalid')
      stub(@images[0]).asset { asset }
    end
        
    it 'should not render a valid img tag if there is no current image' do
      input    = '<r:image title="invalid"><r:tag /></r:image>'
      expected = ''
      pages(:home).should render(input).as(expected)
    end
    
    it 'should render the img tag with the default style if not specified' do
      input    = '<r:image title="first"><r:tag /></r:image>'
      expected = '<img src="/images/first-original.png" />'
      pages(:home).should render(input).as(expected)
    end
    
    it 'should render the img tag with the style specified by the user' do
      input    = '<r:image title="first"><r:tag style="icon"/></r:image>'
      expected = '<img src="/images/first-icon.png" />'
      pages(:home).should render(input).as(expected)
    end
    
  end
  
  describe '<r:image:id>' do
    
    it 'should render the id of the current image context' do
      input    = '<r:image title="sixth"><r:id /></r:image>'
      expected = @images[5].id.to_s
      pages(:home).should render(input).as(expected)
    end
    
    it 'should not render anything if there is no current image context' do
      input    = '<r:image title="invalid"><r:id /></r:image>'
      expected = ''
      pages(:home).should render(input).as(expected)
    end
    
  end
  
  describe '<r:image:title>' do
    
    it 'should render the title of the current image context' do
      input    = '<r:image title="fourth"><r:title /></r:image>'
      expected = 'fourth'
      pages(:home).should render(input).as(expected)
    end
    
    it 'should not render anything if there is no current image context' do
      input    = '<r:image title="invalid"><r:title /></r:image>'
      expected = ''
      pages(:home).should render(input).as(expected)
    end
    
  end
  
  describe '<r:image:position>' do
    
    it 'should render the position of the current image context' do
      input    = '<r:image title="first"><r:position /></r:image>'
      expected = '1'
      pages(:home).should render(input).as(expected)
    end
    
    it 'should not render anything if there is no current image context' do
      input    = '<r:image title="invalid"><r:position /></r:image>'
      expected = ''
      pages(:home).should render(input).as(expected)
    end
    
  end
  
end