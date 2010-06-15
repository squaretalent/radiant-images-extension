module Images
  module ImageTags
    include Radiant::Taggable

    class ImagesTagError < StandardError; end
    
    desc %{ 
      expands if there are images 
      <pre><code><r:if_images>  h2. Yay Images :)  </r:if_images></code></pre>
    }
    tag 'if_images' do |tag|
      tag.expand unless find_images(tag).empty?
    end

    desc %{ 
      expands if there are no images 
      <pre><code><r:unless_images>  h2. No Images :(  </r:unless_images></code></pre>
    }
    tag 'unless_images' do |tag|
      tag.expand if find_images(tag).empty?
    end
    
    desc %{
      creates a context for images
      <pre><code><r:images [search=name]>...</r:images></code></pre>
      * *default* all images
      * *search* a string to search on
      * *params[:query]* a string to search on
    }
    tag 'images' do |tag|
      find_images(tag)
      tag.expand unless tag.locals.images.nil?
    end
    
    desc %{ 
      iterates through each image within the context
      <pre><code><r:images:each>...</r:images:each></code></pre>
    }
    tag 'images:each' do |tag|
      content = ''
      images = find_images(tag)
    
      images.each do |image|
        tag.locals.image = image
        content << tag.expand
      end
      content
    end
    
    desc %{
      creates a context for an image
      <pre><code><r:image [id] [title] [position] [style]>...</r:image></code></pre>
      * *default* current image html tag
      * *id* id of image
      * *title* title of image
    }
    tag 'image' do |tag|
      find_image tag
      find_image_style(tag)

      tag.expand unless tag.locals.image.nil?
    end
    
    desc %{ 
      outputs a html tag of an image 
      <pre><code><r:image:tag [style=#{Radiant::Config['images.default']}] [attributes=nil] /></code></pre>
      * *style* style of image
      * *attributes* string of html attribute     
    }
    tag 'image:tag' do |tag|
      tag.locals.image_style = tag.attr['style'] || find_image_style(tag) #overide the 'singleton'
      
      %{<img src="#{tag.locals.image.url(tag.locals.image_style.to_sym)}" #{tag.attr[:attributes]} />}
    end
    
    desc %{
      outputs the url of an image
      <pre><code><r:image:url [style=#{Radiant::Config['images.default']}] /></code></pre>
    }
    tag 'image:url' do |tag|
      tag.locals.image_style = tag.attr['style'] || find_image_style(tag) #overide the 'singleton'
      
      tag.locals.image.asset.url(tag.locals.image_style.to_sym)
    end
    
    [:title, :caption].each do |symbol|
      desc %{ outputs the #{symbol} of the current image }
      tag "image:#{symbol}" do |tag|
        image = find_image(tag)
        unless image.nil?
          tag.locals.image[symbol]
        end
      end
    end
    
  protected

    def find_images(tag)
      if tag.locals.images
        return tag.locals.images
      elsif tag.attr['search']
        @result = Image.search tag.attr['search']
      elsif params[:query]
        @result = Image.search params[:query]
      elsif Image.all.length > 0
        @result = Image.all
      else
        @result = []
      end
      
      tag.locals.images = @result
    end

    def find_image(tag)
      if tag.locals.image
        return tag.locals.image
      elsif tag.attr['id']
        @result = Image.find :first, :conditions => { :id => tag.attr['id'] }
      elsif tag.attr['title']
        @result = Image.find :first, :conditions => { :title => tag.attr['title'] }
      elsif tag.attr['position']
        @result = Image.find :first, :conditions => { :position => tag.attr['position'] }
      else
        @result = nil
      end
      
      tag.locals.image = @result
    end
    
    def find_image_style(tag)
      if tag.locals.image_style
        @result = tag.locals.image_style
      elsif tag.attr['style']
        @result = tag.attr['style']
      else
        @result = Radiant::Config['images.default']
      end
      
      tag.locals.image_style = @result
    end

  end
end