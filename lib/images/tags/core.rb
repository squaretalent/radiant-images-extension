module Images
  module Tags
    module Core
      include Radiant::Taggable
      
      class TagError < StandardError; end
      
      desc %{
        The namespace for referencing images. You may specify the title
        attribute for this tag to use only images with the specified title.
      
        *Usage:* 
        <pre><code><r:images>...</r:images></code></pre>
      }
      tag 'images' do |tag|
        tag.locals.images = Helpers.current_images(tag)
        
        tag.expand
      end
      
      desc %{
        Expands if images exist
      }
      tag 'images:if_images' do |tag|
        tag.expand if tag.locals.images.present?
      end
      
      desc %{
        Expands unless images exist
      }
      tag 'images:unless_images' do |tag|
        tag.expand unless tag.locals.images.present?
      end
      
      desc %{
        Goes through each of the available images.
        Use the limit and offset attributes to render a specific number of images.
        Use the by and order attributes to control the order of images.
      
        *Usage:* 
        <pre><code><r:images:each [limit=0] [offset=0] [order="asc|desc"] [by="position|title|..."]>...</r:images:each></code></pre>
      }
      tag 'images:each' do |tag|
        context = ''
        
        tag.locals.images.each do |image|
          tag.locals.image = image
          context << tag.expand
        end
        
        content
      end
      
      desc %{
        Expands the current image context
        
        *Usage:*
        <pre><code><r:image>...</r:image></code></pre>
      }
      tag 'image' do |tag|
        tag.locals.image = Helpers.current_image(tag)
        
        tag.expand if tag.locals.image.present?
      end
      
      desc %{
        Outputs the full URL of the image including the filename. Specify the style
        using the style option.
        
        *Usage:*
        <pre><code><r:image title='image'><r:url [style="preview|original"] /></r:image></code></pre>
      }
      tag 'image:url' do |tag|
        style = tag.attr['style'] || :original
        
        tag.locals.image.url(style, false)
      end
      
      [:id, :title].each do |method|
        desc %{
          Outputs the title of the current image
        
          *Usage:*
          <pre><code><r:image title='image'><r:#{method} /></code></pre>
        }
        tag "image:#{method}" do |tag|
          tag.locals.image.send(method)
        end
      end
      
    end
  end
end



# describe '<r:images:each>' do
#   
#   it 'should expand on all images' do
#     content = '<r:images:each>test!</r:images:each>'
#     expected = ''
#     @images.length.times { expected += 'test!' }
#     pages(:home).should render(content).as(expected)
#   end
#   
#   it 'should be running through the image objects' do
#     content = '<r:images:each><r:images:url/></r:images:each>'
#     expected = ''
#     @images.each { |image| expected += image.asset.url }
#     pages(:home).should render(content).as(expected)
#   end
#   
#   it 'should only run through however many images we specify with limit' do
#     content = '<r:images:each limit="2"><r:images:url/></r:images:each>'
#     expected = ''
#     @images[0..1].each { |image| expected += image.asset.url }
#     pages(:home).should render(content).as(expected)
#   end
#   
#   it 'should start at the image number we give it using offset' do
#     content = '<r:images:each limit="2" offset="1"><r:images:url/></r:images:each>'
#     expected = ''
#     @images[1..2].each { |image| expected += image.asset.url }
#     pages(:home).should render(content).as(expected)
#   end
#   
#   it 'should display images in the order we give' do
#     # asc
#     content = '<r:images:each order="asc" by="position"><r:images:url/></r:images:each>'
#     expected = ''
#     @images.each { |image| expected += image.asset.url }
#     pages(:home).should render(content).as(expected)
#     
#     #desc
#     content = '<r:images:each order="desc" by="position"><r:images:url/></r:images:each>'
#     expected = ''
#     @images.reverse.each { |image| expected += image.asset.url }
#     pages(:home).should render(content).as(expected)
#   end
#   
#   it 'should allow us to order images by title' do
#     content = '<r:images:each order="asc" by="title"><r:images:url/></r:images:each>'
#     expected = ''
#     @images.sort! { |a,b| a.title <=> b.title }
#     @images.each { |image| expected += image.asset.url }
#     pages(:home).should render(content).as(expected)
#   end
#       
# end
# 
# describe '<r:images:first>' do
#   
#   it 'should render the first image' do
#     content   = '<r:images:first><r:images:url/></r:images:first>'
#     expected  = @images.first.asset.url
#     pages(:home).should render(content).as(expected)
#   end
#   
# end
# 
# describe '<r:images:if_first>' do
#   
#   it 'should expand the tag if the image is the first' do
#     content   = '<r:images><r:each><r:if_first><r:url /></r:if_first></r:each></r:images>'
#     expected  = @images.first.asset.url
#     pages(:home).should render(content).as(expected)
#   end
#   
# end
# 
# describe '<r:images:unless_first>' do
#   
#   it 'should expand the tag if the image is not the first' do
#     content   = '<r:images><r:each><r:unless_first><r:url /></r:unless_first></r:each></r:images>'
#     expected  = ''
#     
#     @images.each do |image|
#       expected += image.asset.url unless image == @images.first
#     end
#     
#     pages(:home).should render(content).as(expected)
#   end
#   
# end
# 
# describe '<r:if_images>' do
#   
#   it 'should expand the contents if there are images' do
#     content = '<r:images:if_images>test text</r:images:if_images>'
#     expected = 'test text'
#     pages(:home).should render(content).as(expected)
#   end
#   
#   it 'should not expand the contents if there are no images' do
#     Image.delete_all
#     content   = '<r:images:if_images>test text</r:images:if_images>'
#     expected  = ''
#     pages(:home).should render(content).as(expected)    
#   end
#   
#   it 'should expand if the min count is equal to the image count' do
#     min_count = Image.count
#     content   = '<r:images:if_images min_count="' + min_count.to_s + '">test text</r:images:if_images>'
#     expected  = 'test text'
#     pages(:home).should render(content).as(expected)      
#   end
#   
#   it 'should not expand if the min count is greater than the image count' do
#     min_count = Image.count + 1
#     content   = '<r:images:if_images min_count="' + min_count.to_s + '">test text</r:images:if_images>'
#     expected  = ''
#     pages(:home).should render(content).as(expected)    
#   end
#   
# end
# 
# describe '<r:unless_images>' do
#   
#   it 'should not the contents if there are images' do
#     content = '<r:images:unless_images>test text</r:images:unless_images>'
#     expected = ''
#     pages(:home).should render(content).as(expected)
#   end
#   
#   it 'should expand the contents if there are no images' do
#     Image.delete_all
#     content   = '<r:images:unless_images>test text</r:images:unless_images>'
#     expected  = 'test text'
#     pages(:home).should render(content).as(expected)    
#   end
#   
#   it 'should not expand if the min count is equal to the image count' do
#     min_count = Image.count
#     content   = '<r:images:unless_images min_count="' + min_count.to_s + '">test text</r:images:unless_images>'
#     expected  = ''
#     pages(:home).should render(content).as(expected)      
#   end
#   
#   it 'should expand if the min count is greater than the image count' do
#     min_count = Image.count + 1
#     content   = '<r:images:unless_images min_count="' + min_count.to_s + '">test text</r:images:unless_images>'
#     expected  = 'test text'
#     pages(:home).should render(content).as(expected)    
#   end
#   
# end
# 
# describe '<r:images:url/>' do
#   
#   it 'should output the url for a valid image' do
#     content   = '<r:images title="' + @images.first.title + '"><r:images:url/></r:images>'
#     expected  = @images.first.asset.url 
#     pages(:home).should render(content).as(expected)    
#   end
#   
# end
# 
# describe '<r:images:title/>' do
#   
#   it 'should output the title for a valid image' do
#     content   = '<r:images title="' + @images.first.title + '"><r:images:title/></r:images>'
#     expected  = @images.first.title 
#     pages(:home).should render(content).as(expected)    
#   end
#   
# end
# 
# describe '<r:images:tag/>' do
#   
#   it 'should output a valid image tag when given a valid image' do
#     content   = '<r:images title="' + @images.first.title + '"><r:images:tag /></r:images>'
#     expected  = '<img src="' + @images.first.asset.url + '"  alt="' + @images.first.title + '" />' 
#     pages(:home).should render(content).as(expected)    
#   end
#   
#   it 'should output a valid image tag when specifying an image by title' do
#     content   = '<r:images:tag title="' + @images.first.title + '" />'
#     expected  = '<img src="' + @images.first.asset.url + '"  alt="' + @images.first.title + '" />' 
#     pages(:home).should render(content).as(expected)
#   end
#   
#   it 'should output an image tag with the specified size' do
#     content   = '<r:images:tag title="' + @images.first.title + '" size="icon" />'
#     expected  = '<img src="' + @images.first.asset.url(:icon) + '"  alt="' + @images.first.title + '" />' 
#     pages(:home).should render(content).as(expected)
#   end
#   
#   it 'should use the given alt text specified' do
#     content   = '<r:images:tag title="' + @images.first.title + '" alt="new alt text" />'
#     expected  = '<img src="' + @images.first.asset.url + '" alt="new alt text" />' 
#     pages(:home).should render(content).as(expected)
#   end
#   
# end
# 
