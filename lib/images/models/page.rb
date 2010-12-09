module Images
  module Models
    module Page
    
      def self.included(base)
        base.class_eval do
          has_many    :attachments
          has_many    :images,      :through => :attachments
        end
      end
      
    end
  end
end

