class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      string :title
      text :description
      string :tags
      string :filename
      string :content_type
      integer :size
      integer :width
      integer :height
      foreign_key :parent
      string :thumbnail
      datetime :created_at
    end
  end

  def self.down
    drop_table :photos
  end
end
