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
                edit.main.concat %w{edit_header edit_form}
                edit.form.concat %w{edit_title edit_extended_metadata edit_content}
                edit.form_bottom.concat %w{edit_buttons edit_timestamp}
              end
              image.new = image.edit
              image.index = Radiant::AdminUI::RegionSet.new do |index|
                index.image_attributes.concat %w{thumbnail title remove}
              end
              image.remove = image.index
            end
          end
      
      end
    end
  end
end