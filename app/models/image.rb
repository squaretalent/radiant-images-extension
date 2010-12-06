class Image < ActiveRecord::Base

  belongs_to :created_by, :class_name => 'User'
  belongs_to :updated_by, :class_name => 'User'
  
  before_save :assign_title
  validates_uniqueness_of :asset_file_name, :message => 'This file already exists', :allow_nil => true
  validates_uniqueness_of :title
  
  default_scope :order => 'position ASC'
  acts_as_list
  
  has_attached_file :asset,
                    :styles           => lambda { Image.config_styles },
                    :whiny_thumbnails => false,
                    :default_url      => '/images/extensions/images/missing_:style.png',
                    :storage          => Radiant::Config['images.storage'] == 's3' ? :s3 : :filesystem, 
                    :s3_credentials   => {
                      :access_key_id      => ImagesExtension.s3_credentials['access_key_id'],
                      :secret_access_key  => ImagesExtension.s3_credentials['secret_access_key']
                    },
                    :s3_host_alias    => Radiant::Config['s3.host_alias'],
                    :s3_protocol      => Radiant::Config['s3.protocol'],
                    :bucket           => Radiant::Config['s3.bucket'],
                    :url              => Radiant::Config['images.url'],
                    :path             => Radiant::Config['images.path']
                                 
  validates_attachment_presence :asset
  validates_attachment_content_type :asset, :content_type => ['image/jpeg', 'image/png', 'image/gif']
  
  def assign_title
    self.title = self.asset_file_name if title.blank?
  end
  
  def url(style = Radiant::Config['images.default'], include_updated_timestamp = true)
    self.asset.url(style, include_updated_timestamp)
  end
  
  private 
  
  def self.config_styles
    styles = []
    if Radiant::Config['images.styles']
      styles = Radiant::Config['images.styles'].gsub(/\s+/,'').split(',') 
      styles = styles.collect{|s| s.split('=')}.inject({}) {|ha, (k, v)| ha[k.to_sym] = v; ha}
    end
    styles
  end
        
end
