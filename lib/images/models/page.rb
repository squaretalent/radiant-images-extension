module Images
  module Models
    module Page
    
      def self.included(base)
        base.class_eval do
          has_many    :attachments
          has_many    :images,      :through => :attachments
          
          def sort_attachments(ids)
            result = CGI::parse(ids)['attachments[]'].each_with_index.all? do |id, index|
              attachments.find(id).update_attribute(:position,index+1)
            end
          end
          
        end
      end
      
    end
  end
end

