module Images
  module Tags
    class Helpers
    
      class TagError < StandardError; end
      
      class << self
        
        def current_images(tag)
          result = nil
          
          if tag.locals.images.present?
            result = tag.locals.images
          elsif tag.attr['key'] and tag.attr['value']
            result = Image.find(:all, :conditions => { tag.attr['key'].to_sym => tag.attr['value'].to_s }) rescue nil
          else
            result = Image.all
          end
          
          result
        end
        
        def current_image(tag)
          result = nil
          
          if tag.locals.image.present?
            result = tag.locals.image
          elsif tag.attr['id']
            result = Image.find(tag.attr['id'])
          elsif tag.attr['title']
            result = Image.find_by_title(tag.attr['title'])
          end
          
          result
        end
        
        def image_options(tag)
          attr = tag.attr.symbolize_keys
          by = attr[:by] || 'position'
          order = attr[:order] || 'asc'
          
          options = {
            :order => "#{by} #{order}",
            :limit => attr[:limit] || nil,
            :offset => attr[:offset] || nil
          }
        end
        
        def image_and_options(tag)
          options = tag.attr.dup
          [find_image(tag, options), options]
        end
        
      end
      
    end
  end
end