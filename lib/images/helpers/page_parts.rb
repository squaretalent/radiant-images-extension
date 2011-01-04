module Images::Helpers::PageParts
  
  def parts
    [PagePart, *PagePart.descendants]
  end
  
  def parts_with_images_removed
    parts = parts_without_images_removed
    
    if @page.parts.map.any? { |part| part.name.downcase =~ /(image)/ }
      parts.reject! { |part| part.name.downcase =~ /(image)/ }
    end
    
    parts
  end
  alias_method_chain :parts, :images_removed
  
end