module Images
  module Tags
    class Helper
      
      CONDITIONS = ['images.position','images.title','images.id']
      
      class TagError < StandardError; end
      
      class << self
        
        def current_images(tag)
          @conditions = CONDITIONS.dup
          
          case 
          when tag.locals.images.present?
            images = tag.locals.images
          when tag.locals.page.images.present?
            @conditions.map! { |term| term.gsub('images.position','attachments.position') }
            images = tag.locals.page.attachments
            images = images.all image_conditions(tag).merge(image_options(tag)).merge(:joins => 'JOIN images ON images.id = attachments.image_id')
          else
            images = Image.all image_conditions(tag).merge(image_options(tag))
          end
          
          return images
          
        end
        
        def current_image(tag)
          @conditions = CONDITIONS.dup
          
          tag.locals.image = image_conditions(tag).present? ? nil : tag.locals.image
          
          case
          when tag.locals.image.present?
            image = tag.locals.image
          when tag.locals.image.nil?
            case
            when tag.locals.images.first.is_a?(Image)
              query = Image.all image_conditions(tag).merge(image_options(tag))
            else
              @conditions.map! { |term| term.gsub('images.position','attachments.position') }
              query = Attachment.all image_conditions(tag).merge(image_options(tag)).merge(:joins => 'JOIN images ON images.id = attachments.image_id')
              query = query.map { |a| a.image }
            end
            image = (tag.locals.images && query).first
          else
            image = Image.first image_conditions(tag).merge(image_options(tag))
          end
          
          image
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