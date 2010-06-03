class AddPositionToImages < ActiveRecord::Migration
  def self.up
    add_column :images, :position, :integer
    
    Image.all.each_with_index do |image, i|
      image.update_attribute('position', i+1)
    end
  end

  def self.down
    remove_column :images, :position
  end
end
