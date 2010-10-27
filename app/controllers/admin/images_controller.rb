class Admin::ImagesController < Admin::ResourceController
  
  before_filter :index_assets, :only => [ :index ]
  before_filter :edit_assets, :only => [ :show, :edit ]
  around_filter :rescue_s3_exceptions, :only => [:create, :edit, :destroy]
  
  def index
    @images = Image.paginate :page => params[:page], :per_page => params[:pp] || 25
  end
  
  
private

  def index_assets
    include_stylesheet 'admin/extensions/images/index'
  end
  
  def edit_assets
    include_stylesheet 'admin/extensions/images/edit'
  end
  
  def rescue_s3_exceptions
    begin
      yield
    rescue AWS::S3::ResponseError => e
      flash[:error] = e.to_s
      redirect_to admin_images_url
    end
  end
  
end
