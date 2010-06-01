class Image < ActiveRecord::Base
  
  belongs_to :created_by, :class_name => 'User'
  belongs_to :updated_by, :class_name => 'User'
  
  before_save :assign_title
  validates_uniqueness_of :asset_file_name, :message => 'This file already exists'
  #validates_attachment_presence :asset, :message => "You must choose a file to upload!"
  
  has_attached_file :asset,
                    :styles           => lambda { Image.config_styles },
                    :whiny_thumbnails => false,
                    :storage          => :s3, 
                    :default_url      => '/images/extensions/images/missing_:style.png',
                    :s3_credentials   => {
                      :access_key_id      => Radiant::Config['s3.key'],
                      :secret_access_key  => Radiant::Config['s3.secret']
                    },
                    :s3_host_alias    => Radiant::Config['s3.bucket'],
                    :bucket           => Radiant::Config['s3.bucket'],
                    :path             => Radiant::Config['s3.path'],
                    :url              => ':s3_alias_url'
  

  def self.config_styles
    styles = []
    if settings = Radiant::Config['images.styles']
      styles = settings.gsub(/\s+/,'').split(',') 
      styles.collect{|s| s.split('=')}.inject({}) {|ha, (k, v)| ha[k.to_sym] = v; ha}
      styles.merge
    end
    styles
  end

  def assign_title
    self.title = self.asset_file_name if title.blank?
  end
  
private

  class << self
    def search(search)
      unless search.blank?
        queries = []
        queries << 'LOWER(title) LIKE (:term)'
        queries << 'LOWER(caption) LIKE (:term)'
        queries << 'LOWER(asset_file_name) LIKE (:term)'

        sql = queries.join(' OR ')
        @conditions = [sql, {:term => "%#{search.downcase}%" }]
      else
        @conditions = []
      end
      options = { :conditions => @conditions }
      self.all(options)
    end
  end
    
end
