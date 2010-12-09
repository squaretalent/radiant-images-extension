class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments, :force => true do |t|
      t.integer :position,     :default => 1
      t.integer :image_id
      t.integer :page_id
      t.integer :created_by_id
      t.integer :updated_by_id
    end
    add_index :attachments, ["image_id"], :name => "index_attachments_on_image_id"
    add_index :attachments, ["page_id"],  :name => "index_attachments_on_page_id"
    add_index :attachments, ["position"], :name => "index_attachments_on_position"
    
  end

  def self.down
    drop_table :attachments
  end
end
