class Admin::ImagesController < Admin::ResourceController
  
  before_filter :index_assets, :only => [ :index ]
  before_filter :edit_assets, :only => [ :show, :edit ]
  
  # GET /admin/images
  # GET /admin/images.js
  # GET /admin/images.xml
  # GET /admin/images.json                                        AJAX and HTML
  #----------------------------------------------------------------------------
  def search 
    @images = Image.search params[:search], params[:p]

    respond_to do |format|
      format.html { render }
      format.js { render @images }
      format.xml { render :xml => @images.to_xml }
      format.json { render :json => @images.to_json }
    end
  end
  
private

  def index_assets
    include_javascript 'admin/extensions/images/index'
    include_stylesheet 'admin/extensions/images/index'
  end
  
  def edit_assets
    include_javascript 'admin/extensions/images/edit'
    include_stylesheet 'admin/extensions/images/edit'
  end
  
end
