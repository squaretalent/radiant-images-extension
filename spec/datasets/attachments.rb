class AttachmentsDataset < Dataset::Base
  
  uses :images, :pages
  
  def load
    
    { :parent => [ :first, :second, :third ], :child => [ :fourth, :fifth, :sixth ]}.map do |page, attachments|
      attachments.each_with_index do |attachment, i|
        create_record :attachment, attachment,
          :image    => images(attachment),
          :page     => pages(page),
          :position => i+1
        pages(page).attachments << attachments(attachment)
      end
    end
    
  end
end