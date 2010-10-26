# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'

require 'paperclip'
require 'aws/s3'

class ImagesExtension < Radiant::Extension
  version "0.1"
  description "Images stores images on s3"
  url "http://github.com/squaretalent/radiant-images-extension"
    
  extension_config do |config|
    config.gem 'paperclip', :version => '~> 2.3.1.1'
    config.gem 'aws-s3', :version => '>= 0.6.2', :lib => 'aws/s3'
    config.gem 'acts_as_list', :version => '>= 0.1.2'
    
    if RAILS_ENV == :test
      config.gem 'rr', :version => '>= 1.0.0'
    end
    
  end
  
  def activate
    
    unless defined? admin.image
      Radiant::AdminUI.send :include, Images::Interface::Admin::Images
      admin.image = Radiant::AdminUI.load_default_image_regions
    end
    
    
    Page.send :include, Images::Tags::Core

    UserActionObserver.instance.send :add_observer!, Image 
    
    tab 'Content' do
      add_item 'Images', '/admin/images', :after => 'Pages'
    end
    
    Radiant::Config['images.default'] ||= "original"
    Radiant::Config['images.path']    ||= ":rails_root/public/:class/:basename-:style.:extension"
    Radiant::Config['images.storage'] ||= "local"
    Radiant::Config['images.styles']  ||= "icon=45x45#,preview=200x200#,normal=640x640#"
    Radiant::Config['images.url']     ||= "/:class/:basename-:style.:extension"
    
    Radiant::Config['s3.bucket']      ||= "set"
    Radiant::Config['s3.host_alias']  ||= "set"
    Radiant::Config['s3.key']         ||= "set"
    Radiant::Config['s3.secret']      ||= "set"
    

    unless Radiant::Config["images.image_magick_path"].nil?
      # Passenger needs this configuration to work with Image magick
      # Radiant::Config["assets.image_magick_path"] = '/usr/local/bin/' # OS X Homebrew
      Paperclip.options[:image_magick_path] = Radiant::Config["images.image_magick_path"]
    end
    
  end
end
