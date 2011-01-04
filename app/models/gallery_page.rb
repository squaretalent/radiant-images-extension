class GalleryPage < Page
  
  part 'images',      :page_part_type => 'ImagesPagePart'
  
  remove_part 'body'
  remove_part 'extended'
  
end