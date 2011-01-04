class Admin::AttachmentsController < Admin::ResourceController
  
  responses do |r|
    r.create.default do
      flash[:notice] = 'Successfully created the Image.'
      redirect_to :back
    end
    r.create.default do
      if params[:attachment][:image_attributes].present?
        # We're creating the image as well, no ajax
        redirect_to :back
      else
        render :partial => '/admin/images/edit/attachment', :locals => { :attachment => model }
      end
    end
    r.destroy.default do
      render :partial => '/admin/images/edit/image', :locals => { :image => Image.find(params[:image_id]) }
    end
    r.invalid.default do
      flash[:error] = 'Could not create Image, perhaps it already exists?'
      redirect_to :back
    end
  end
  
  def sort
    @page = Page.find(params[:page_id])
    sort = @page.sort_attachments(params[:attachments])
    
    if sort
      render :text => 'Successfully sorted images'
    else
      render :text => 'Could not sort', :status => :unprocessable_entity
    end
  end
  
end