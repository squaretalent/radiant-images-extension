class Admin::ImagesController < Admin::ResourceController
  
  before_filter :index_assets, :only => [ :index ]
  before_filter :edit_assets, :only => [ :show, :edit ]
  
  # GET /admin/images
  # GET /admin/images.js
  # GET /admin/images.xml
  # GET /admin/images.json                                        AJAX and HTML
  #----------------------------------------------------------------------------
  def index 
    @images = Image.search params[:search]

    respond_to do |format|
      format.html { render }
      format.js { render @images }
      format.xml { render :xml => @images.to_xml }
      format.json { render :json => @images.to_json }
    end
  end
  
  # GET /admin/images/1
  # GET /admin/images/1.js
  # GET /admin/images/1.xml
  # GET /admin/images/1.json                                      AJAX and HTML
  #----------------------------------------------------------------------------
  def show
    @image = Image.find(params[:id])

    if @image
      respond_to do |format|
        format.html { render }
        format.js { render @image }
        format.xml { render :xml => @image.to_xml }
        format.json { render :json => @image.to_json }
      end
    else
      respond_to do |format|
        @message = "Could not find image."      
        format.html { 
          flash[:notice] = @message
          redirect_to admin_shop_products_path 
        }
        format.js { render :text => @message, :status => :unprocessable_entity }
        format.xml { render :xml => { :message => @message }, :status => :unprocessable_entity }
        format.json { render :json => { :message => @message }, :status => :unprocessable_entity }
      end
    end
  end

  # POST /admin/images/1
  # POST /admin/images/1.js
  # POST /admin/images/1.xml
  # POST /admin/images/1.json                                     AJAX and HTML
  #----------------------------------------------------------------------------
  def create
    if params[:swfupload]
      # crazy shit here
    else
      @image = Image.new params[:image]
      if @image.save
        respond_to do |format|
          format.html { 
            flash[:notice] = "Image created successfully."
            redirect_to edit_admin_image_path(@shop_product) if params[:continue]
            redirect_to admin_images_path unless params[:continue]
          }
          format.js { render :partial => '/admin/images/excerpt', :locals => { :excerpt => @shop_product } }
          format.xml { redirect_to "/admin/images/#{@image.id}.xml" }
          format.json { redirect_to "/admin/images/#{@image.id}.json" }
        end
      else
        respond_to do |format|
          format.html { 
            flash[:error] = "Unable to create new image."
            render :new
          }
          format.js { render :text => @image.errors.to_json, :status => :unprocessable_entity }
          format.xml { render :xml => @image.errors.to_xml, :status => :unprocessable_entity }
          format.json { render :json => @image.errors.to_json, :status => :unprocessable_entity }
        end
      end
    end
  end
  
  # DELETE /admin/images/1
  # DELETE /admin/images/1.js
  # DELETE /admin/images/1.xml
  # DELETE /admin/images/1.json                                   AJAX and HTML
  #----------------------------------------------------------------------------
  def destroy
    @image = Image.find params[:id]
    
    if @image
      @image.destroy
      respond_to do |format|
        @message = "Image deleted successfully."
        format.html { 
          flash[:notice] = @message
          redirect_to admin_images_path 
        }
        format.js { render :text => @message, :status => 200 }
        format.xml { render :xml => { :message => @message }, :status => 200 }
        format.json { render :json => { :message => @message }, :status => 200 }
      end
    else
      respond_to do |format|
        @message = "Could not find image."      
        format.html { 
          flash[:notice] = @message
          redirect_to admin_shop_products_path 
        }
        format.js { render :text => @message, :status => :unprocessable_entity }
        format.xml { render :xml => { :message => @message }, :status => :unprocessable_entity }
        format.json { render :json => { :message => @message }, :status => :unprocessable_entity }
      end
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
