class ImagesController < ApplicationController

  no_login_required

  def show
    begin 
      @image = Image.find(params[:id])
      redirect_to @image.url
    rescue Exception => e
      flash[:notice] = "Image could not be found."
      redirect_to Radiant::Config['images.missing'].to_s.gsub(':style', params[:style])
    end
  end
  
end