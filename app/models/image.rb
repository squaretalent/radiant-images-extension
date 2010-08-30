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
                    
                    :storage          => :s3,
                    :s3_credentials   => {
                      :access_key_id      => Radiant::Config['s3.key'],
                      :secret_access_key  => Radiant::Config['s3.secret']
                    },
                    :bucket           => Radiant::Config['s3.bucket'],
                    :path             => Radiant::Config['s3.path']
                                        
  validates_attachment_presence :asset
  validates_attachment_content_type :asset, :content_type => ['image/jpeg', 'image/png', 'image/gif']

  def assign_title
    self.title = self.asset_file_name if title.blank?
  end

  def basename
    File.basename(asset_file_name, ".*") if asset_file_name
  end

  def extension
    asset_file_name.split('.').last.downcase if asset_file_name
  end
  
  # returns the url of the asset
  def url(style = :original, secure = false)
    style  = style.to_s
    prefix = secure ? 'https://' : 'http://'
    domain = Radiant::Config['s3.host_alias'].empty? ? 's3.amazonaws.com' : Radiant::Config['s3.host_alias']
    bucket = Radiant::Config['s3.host_alias'].empty? ? '/' + Radiant::Config['s3.bucket'] : ''
    
    url = prefix + domain + bucket + '/images/' + basename + '-' + style + '.' + extension
  end
  
private

  class << self
    def search(search, page)
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
      
      self.all :conditions => @conditions
      
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
