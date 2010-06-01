# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'

class ImagesExtension < Radiant::Extension
  version "0.1"
  description "Images stores images on an s3 server"
  url "http://github.com/squaretalent/radiant-images-extension"
    
  extension_config do |config|
    config.gem 'paperclip', :version => '2.3.1.1'
    config.gem 'aws-s3', :version => '0.6.2', :lib => 'aws/s3'
    config.gem 'acts_as_list', :version => '0.1.2'
    config.gem 'rr', :version => '0.10.11'
  end
  
  def activate
    unless defined? admin.image
      Radiant::AdminUI.send :include, Images::AdminUI
      admin.image = Radiant::AdminUI.load_default_image_regions
    end
    
    Page.send :include, Images::ImageTags, Images::PageExtensions

    UserActionObserver.instance.send :add_observer!, Image 
    
    tab 'Content' do
      add_item 'Images', '/admin/images', :after => 'Pages'
    end
    
    Radiant::Config['image.styles'] ||= "thumbnail=200x200#,normal=640x640#"
    Radiant::Config['image.default']||= "original"
    
    Radiant::Config['s3.key']       ||= "123456"
    Radiant::Config['s3.secret']    ||= "123456789ABCDEF"
    Radiant::Config['s3.bucket']    ||= "s3.domain.tld"
    Radiant::Config['s3.path']      ||= ":class/:basename_:style.:extension"
    
  end
end
