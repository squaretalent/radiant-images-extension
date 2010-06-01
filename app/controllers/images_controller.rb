class ImagesController < ApplicationController

  no_login_required

  def show
    begin 
      @image = Image.find params[:id]
      
      response.headers["Content-Type"]        = @image.asset_content_type
      response.headers['Content-Disposition'] = "attachment; filename=#{@image.asset_file_name}" 
      response.headers['Content-Length']      = @image.asset_file_size
      
      render :nothing => true
    rescue
      respond_to do |format|
        @message = "Could not find image."      
        format.html { 
          flash[:notice] = @message
          redirect_to not_found_path 
        }
        format.js { render :text => @message, :status => :unprocessable_entity }
        format.xml { render :xml => { :message => @message }, :status => :unprocessable_entity }
        format.json { render :json => { :message => @message }, :status => :unprocessable_entity }
      end
    end
  end
  
end