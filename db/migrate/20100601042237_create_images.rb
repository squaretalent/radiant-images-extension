class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.string  :title
      t.string  :caption
      
      t.string  :asset_file_name
      t.string  :asset_content_type
      t.string  :asset_file_size
      
      t.integer :created_by
      t.integer :updated_by
      t.string  :created_at
      t.string  :updated_at

      t.timestamps
    end
  
  end

  def self.down
    drop_table :images
  end
end
