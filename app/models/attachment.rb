require 'acts_as_list'

class Attachment < ActiveRecord::Base
  
  default_scope :order => 'attachments.position ASC'
  
  belongs_to    :page
  belongs_to    :image
  
  belongs_to    :created_by,  :class_name => 'User'
  belongs_to    :updated_by,  :class_name => 'User'
  
  acts_as_list  :scope =>     :page
  
  def url(*params)
    image.url(*params) rescue nil
  end
  
  def title(*params)
    image.title(*params) rescue nil
  end
  
  def caption(*params)
    image.caption(*params) rescue nil
  end
  
  # Overloads the base to_json to return what we want
  def to_json(*attrs); super self.class.params; end
  
  class << self
    
    # Returns attributes attached to the attachment
    def attrs
      [ :id, :title, :caption, :image_file_name, :image_content_type, :image_file_size ]
    end
    
    # Returns methods with usefuly information
    def methds
      [ :url, :title, :caption ]
    end
    
    # Returns a custom hash of attributes on the product
    def params
      { :only  => self.attrs, :methods => self.methds }
    end
    
  end
  
end