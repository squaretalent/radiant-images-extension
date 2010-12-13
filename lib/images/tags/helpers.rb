module Images
  module Tags
    class Helpers
      
      CONDITIONS = ['images.position','images.title','images.id']
      
      class TagError < StandardError; end
      
      class << self
        
        def current_images(tag)
          @conditions = CONDITIONS.dup
          
          if tag.locals.images.nil?
            return Image.all image_conditions(tag).merge(image_options(tag))
          end
        
          if tag.locals.images.empty?
            return tag.locals.images
          end
        
          images = tag.locals.images
          if images.first.is_a?(Image)
            images.all image_conditions(tag).merge(image_options(tag))
          else            
            # We're looking based on attachment positions, not image positions
            @conditions.map! { |term| term.gsub('images.position','attachments.position') }
            images.all image_conditions(tag).merge(image_options(tag)).merge(:joins => 'JOIN images ON images.id = attachments.image_id')
          end
        end
        
        def current_image(tag)
          @conditions = CONDITIONS.dup
          
          # Images exist, and we're not looking to change the scope
          if tag.locals.image.present? and image_conditions(tag).empty?
            return tag.locals.image
          end
          
          unless tag.locals.images.nil?
            images = tag.locals.images
            if images.first.is_a?(Image)
              query = Image.all image_conditions(tag).merge(image_options(tag))
            else
              @conditions.map! { |term| term.gsub('images.position','attachments.position') }
              query = Attachment.all image_conditions(tag).merge(image_options(tag)).merge(:joins => 'JOIN images ON images.id = attachments.image_id')
              query = query.map { |a| a.image }
            end
            return (query && images).first
          else
            return Image.first image_conditions(tag).merge(image_options(tag))
          end
        end
        
        private
        
        def image_options(tag)
          attr = tag.attr.symbolize_keys
          
          options = {
            :order  => "#{attr[:by]  || 'position'} #{attr[:order] || 'asc'}",
            :limit  => attr[:limit]  || nil,
            :offset => attr[:offset] || nil
          }
        end
        
        def image_conditions(tag)
          attr = tag.attr.symbolize_keys
          
          @conditions.reject! { |term| attr[term.split('.').last.to_sym].nil? }
          
          query = @conditions.map { |term| %{#{term} = ?} }.join(' AND ')
          values = @conditions.map { |term| %{#{attr[term.split('.').last.to_sym]}} }
          query.blank? ? {} : { :conditions => [query,*values] } 
        end
        
      end
      
    end
  end
end