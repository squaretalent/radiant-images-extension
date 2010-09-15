# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'

require 'paperclip'

class ImagesExtension < Radiant::Extension
  version "0.1"
  description "Images stores images on s3"
  url "http://github.com/squaretalent/radiant-images-extension"
    
  extension_config do |config|
    config.gem 'paperclip',     :version => '2.3.1.1'
    config.gem 'aws-s3',        :version => '0.6.2', :lib => 'aws/s3'
    config.gem 'acts_as_list',  :version => '0.1.2'
    config.gem 'rr',            :version => '0.10.11'
    config.gem 'acts_as_list'
    config.gem 'will_paginate'
  end
    
  UserActionObserver.instance.send :add_observer!, Image
  
  def activate
    
    unless defined? admin.image
      Radiant::AdminUI.send :include, Images::AdminUI
      admin.image = Radiant::AdminUI.load_default_image_regions
    end
    
    Page.send :include, Images::ImageTags, Images::PageExtensions
    
    tab 'Content' do
      add_item 'Images', '/admin/images', :after => 'Pages'
    end
    
    Radiant::Config['images.styles']  ||= 'icon=45x45#,preview=200x200#,normal=640x640#'
    Radiant::Config['images.default'] ||= 'normal'
    Radiant::Config['images.missing'] ||= '/images/extensions/images/missing_:style.png'
    
    Radiant::Config['s3.key']         ||= 'set'
    Radiant::Config['s3.secret']      ||= 'set'
    Radiant::Config['s3.bucket']      ||= 'fs.domain.com'
    Radiant::Config['s3.path']        ||= ':class/:basename-:style.:extension'
    
    unless Radiant::Config["images.image_magick_path"].nil?
      # Passenger needs this configuration to work with Image magick
      # Radiant::Config["assets.image_magick_path"] = '/usr/local/bin/' # OS X Homebrew
      Paperclip.options[:image_magick_path] = Radiant::Config["images.image_magick_path"]
    end
    
  end
end
