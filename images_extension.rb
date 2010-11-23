require 'paperclip'
require 'aws/s3'
require 'acts_as_list'

class ImagesExtension < Radiant::Extension
  version YAML::load_file(File.join(File.dirname(__FILE__), 'VERSION'))
  description "Images stores images on s3"
  url "http://github.com/squaretalent/radiant-images-extension"
    
  extension_config do |config|
    config.gem 'paperclip',    :lib => 'paperclip'
    config.gem 'aws-s3',       :lib => 'aws/s3'
    config.gem 'acts_as_list', :lib => 'acts_as_list'
  end
  
  def activate
    
    unless defined? admin.image
      Radiant::AdminUI.send :include, Images::Interface::Admin::Images
      admin.image = Radiant::AdminUI.load_default_image_regions
    end
    
    Paperclip::Railtie.insert
    
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
    
    #Radiant::Config['s3.bucket']
    #Radiant::Config['s3.host_alias']
    #Radiant::Config['s3.key']
    #Radiant::Config['s3.secret']
    
    unless Radiant::Config["images.image_magick_path"].nil?
      # Passenger needs this configuration to work with Image magick
      # Radiant::Config["assets.image_magick_path"] = '/usr/local/bin/' # OS X Homebrew
      Paperclip.options[:image_magick_path] = Radiant::Config["images.image_magick_path"]
    end
    
  end
  
  def self.s3_credentials
    result = {}
    if File.exists?(File.join(Rails.root, 'config', 'amazon_s3.yml'))
      result.merge!(YAML.load_file(File.join(Rails.root, 'config', 'amazon_s3.yml'))[RAILS_ENV])
    else
      result['access_key_id']     = Radiant::Config['s3.key']
      result['secret_access_key'] = Radiant::Config['s3.secret']
    end
    result
  end
  
end
