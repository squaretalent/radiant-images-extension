module Images
  module AdminUI

   def self.included(base)
     base.class_eval do

        attr_accessor :image
        alias_method :images, :image
      
        protected

          def load_default_image_regions
            returning OpenStruct.new do |image|
              image.edit = Radiant::AdminUI::RegionSet.new do |edit|
                edit.top.concat %w{ title }
                edit.form.concat %w{ asset title caption upload popups }
                edit.form_bottom.concat %w{ buttons timestamps }
              end
              image.new = image.edit
              image.index = Radiant::AdminUI::RegionSet.new do |index|
                index.attributes.concat %w{thumbnail title modify }
                index.bottom.concat %w{ create search }
                index.paginate.concat %w{ pagination }
              end
              image.search = image.index
              image.remove = image.index
            end
          end
      
      end
    end
  end
end