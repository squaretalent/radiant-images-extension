class ChangeImagesToCreatedById < ActiveRecord::Migration
  def self.up
    add_column :images,    :created_by_id,   :integer
    add_column :images,    :updated_by_id,   :integer
    remove_column :images, :created_by
    remove_column :images, :updated_by
  end

  def self.down
    add_column :images,    :created_by_id,   :integer
    add_column :images,    :updated_by_id,   :integer
    remove_column :images, :created_by
    remove_column :images, :updated_by
  end
end
