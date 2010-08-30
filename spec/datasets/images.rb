class ImagesDataset < Dataset::Base
  def load
    images = [ :first, :second, :third, :fourth, :fifth ]
    
    images.each_with_index do |image, i|
      create_record :image, image.to_sym,
        :title              => image.to_s,
        :asset_file_name    => "#{image.to_s}.png",
        :asset_content_type => "image/png",
        :asset_file_size    => i+1*1000,
        :position           => i+1
    end
  end
end