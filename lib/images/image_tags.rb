module Images
  module ImageTags
    include Radiant::Taggable
    
    class TagError < StandardError; end

    desc %{
      The namespace for referencing images. You may specify the title
      attribute for this tag to use only images with the specified title.
      
      *Usage:* 
      <pre><code><r:images [title="image_title"]>...</r:images></code></pre>
    }
    tag 'images' do |tag|
      tag.locals.image = Image.find_by_title(tag.attr['title']) || Image.find(tag.attr['id']) unless tag.attr.empty?
      tag.expand
    end
    
    desc %{
      Goes through each of the available images.
      Use the limit and offset attributes to render a specific number of images.
      Use the by and order attributes to control the order of images.
      
      *Usage:* 
      <pre><code><r:images:each [limit=0] [offset=0] [order="asc|desc"] [by="position|title|..."]>...</r:images:each></code></pre>
    }
    tag 'images:each' do |tag|
      options = tag.attr.dup
      result = []
      images = Image.find(:all, images_find_options(tag))
      tag.locals.images = images
      images.each do |image|
        tag.locals.image = image
        result << tag.expand
      end
      result
    end
    
    desc %{
      Renders the first image.
      
      *Usage:* 
      <pre><code><r:images:first>...</r:images:first></code></pre>
    }
    tag 'images:first' do |tag|
      images = tag.locals.images
      if first = images.first
        tag.locals.image = first.image
        tag.expand
      end
    end
    
    desc %{
      Renders the contained elements only if the current image is the first.

      *Usage:*
      <pre><code><r:if_first>...</r:if_first></code></pre>
    }
    tag 'images:if_first' do |tag|
      images = tag.locals.images
      image = tag.locals.image
      if image == images.first
        tag.expand
      end
    end
      
    desc %{
      Renders the contained elements only if the current image is not the first.

      *Usage:*
      <pre><code><r:unless_first>...</r:unless_first></code></pre>
    }
    tag 'images:unless_first' do |tag|
      images = tag.locals.images
      image = tag.locals.image
      if image != images.first
        tag.expand
      end
    end
      
    desc %{
      Renders the contained elements only if the current contextual page has one or
      more image. The min_count attribute specifies the minimum number of required
      images.

      *Usage:*
      <pre><code><r:if_images [min_count="n"]>...</r:if_images></code></pre>
    }
    tag 'if_images' do |tag|
      count = tag.attr['min_count'] && tag.attr['min_count'].to_i || 1
      images = tag.locals.images.count
      tag.expand if images >= count
    end
      
    desc %{
      Renders the contained elements only if the current contextual page does not
      have one or more image. The min_count attribute specifies the minimum number 
      of required images.

      *Usage:*
      <pre><code><r:if_images [min_count="n"]>...</r:if_images></code></pre>
    }
    tag 'unless_images' do |tag|
      count = tag.attr['min_count'] && tag.attr['min_count'].to_i || 1
      images = tag.locals.images.count
      tag.expand unless images >= count
    end

    desc %{
      Outputs the full URL of the image including the filename. Specify the style
      using the style option.
    }
    tag 'images:url' do |tag|
      style = tag.attr['style'] || :original
      image, options = image_and_options(tag)
      image.url(style) rescue nil
    end

    desc %{
      Outputs the image tag for the current image. Use the size option to 
      specify which size version of the image is to be used.
      
      *Usage:*
      <pre><code><r:images:tag [title="image_title"] [size="icon|thumbnail"]></code></pre>
    }
    tag 'images:tag' do |tag|
      image, options = image_and_options(tag)
      size = options['size'] ? options.delete('size') : 'original'
      alt = " alt='#{image.title}'" unless tag.attr['alt'] rescue nil
      attributes = options.inject('') { |s, (k, v)| s << %{#{k.downcase}="#{v}" } }.strip
      attributes << alt unless alt.nil?
      url = image.url size
      %{<img src="#{url}" #{attributes unless attributes.empty?} />} rescue nil
    end
    
    
    private
      def image_and_options(tag)
        options = tag.attr.dup
        [find_image(tag, options), options]
      end

      def find_image(tag, options)
        raise TagError, "'title' attribute required" unless title = options.delete('title') or id = options.delete('id') or tag.locals.image
        tag.locals.image || Image.find_by_title(title) || Image.find(id)
      end

      def images_find_options(tag)
        attr = tag.attr.symbolize_keys
        by = attr[:by] || 'position'
        order = attr[:order] || 'asc'

        options = {
          :order => "#{by} #{order}",
          :limit => attr[:limit] || nil,
          :offset => attr[:offset] || nil
        }
      end
    

  end
end