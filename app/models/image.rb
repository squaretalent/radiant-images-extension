class Image < ActiveRecord::Base
  
  belongs_to :created_by, :class_name => 'User'
  belongs_to :updated_by, :class_name => 'User'
  
  before_save :assign_title
  validates_uniqueness_of :asset_file_name, :message => 'This file already exists', :allow_nil => true
  validates_uniqueness_of :title

  has_attached_file :asset,
                    :styles           => lambda { Image.config_styles },
                    :whiny_thumbnails => false,
                    :default_url      => '/images/extensions/images/missing_:style.png',
                    
                    :storage          => :s3,
                    :s3_credentials   => {
                      :access_key_id      => Radiant::Config['s3.key'],
                      :secret_access_key  => Radiant::Config['s3.secret']
                    },
                    :s3_host_alias    => Radiant::Config['s3.bucket'],
                    :bucket           => Radiant::Config['s3.bucket'],
                    :path             => Radiant::Config['s3.path'],
                    :url              => ':s3_alias_url'

  def assign_title
    self.title = self.asset_file_name if title.blank?
  end

  def basename
    File.basename(asset_file_name, ".*") if asset_file_name
  end

  def extension
    asset_file_name.split('.').last.downcase if asset_file_name
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
    
    def config_styles
      styles = []

      if Radiant::Config['images.styles']
        styles = Radiant::Config['images.styles'].gsub(/\s+/,'').split(',') 
        styles = styles.collect{|s| s.split('=')}.inject({}) {|ha, (k, v)| ha[k.to_sym] = v; ha}
      end
      styles
    end
  end
    
end
