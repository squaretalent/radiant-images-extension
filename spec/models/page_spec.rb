require File.dirname(__FILE__) + "/../spec_helper"

describe Image do
  dataset :pages, :attachments
  
  describe '#sort_attachments' do
    
    it 'should update the order of images sent through' do
      originally  = pages(:home).attachments
      attachments = originally.reverse.map { |a| "attachments[]=#{a.id}" }.join("&")
      
      pages(:home).sort_attachments(attachments)
      attachments = pages(:home).attachments
      attachments.first.should === originally.last
      attachments.last.should  === originally.first
    end
    
  end
  
end