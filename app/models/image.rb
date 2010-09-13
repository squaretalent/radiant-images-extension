class Image < ActiveRecord::Base

  belongs_to :created_by, :class_name => 'User'
  belongs_to :updated_by, :class_name => 'User'

  before_save :normalise_filename  
  before_save :normalise_title

  validates_uniqueness_of :asset_file_name, :message => 'This file already exists', :allow_nil => true
  validates_uniqueness_of :title
  validates_presence_of :asset_file_name
  
  default_scope :order => 'images.position ASC'
  acts_as_list

  has_attached_file :asset,
                    :styles           => lambda { Image.config_styles },
                    :whiny_thumbnails => false,
                    :default_url      => Radiant::Config['images.missing'] || 'missing fallback',
                    
                    :storage          => :s3,
                    :s3_credentials   => {
                      :access_key_id      => Radiant::Config['s3.key'] || 'missing key',
                      :secret_access_key  => Radiant::Config['s3.secret'] || 'missing secret'
                    },
                    :s3_host_alias    => Radiant::Config['s3.bucket'] || 'missing bucket',
                    :bucket           => Radiant::Config['s3.bucket'] || 'missing bucket',
                    :path             => Radiant::Config['s3.path'] || 'missing path',
                    :url              => ':s3_alias_url'
  
  Paperclip.interpolates :basename do |attachment, style|
    attachment.instance.basename
  end
  
  Paperclip.interpolates :extension do |attachment, style|
    attachment.instance.extension
  end
                    
  def normalise_filename
    self.asset_file_name.downcase.gsub(' ', '') unless self.asset_file_name.blank?
  end

  def normalise_title
    self.title = asset_file_name.downcase.match('^(.*)\.')[1].gsub(/( _|-|\(|\)|\.)/, ' ') if self.title.blank?
  end

  def basename
    asset_file_name.downcase.match('^(.*)\.')[1].gsub('(\(|\)|-|.)', '_') unless self.asset_file_name.blank?
  end

  def extension
    asset_file_name.downcase.match('\.([^\.]+)$')[1] unless self.asset_file_name.blank?
  end
  
  def url(*params)
    self.asset.url(*params)
  end
  
  class << self
    def search(search = [], page = nil, pp = 2)
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
      
      self.paginate(
        :conditions => @conditions,
        :page => page,
        :per_page => pp
      )
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
