class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments do |t|
      foreign_key :attachable
      string :attachable_type
      foreign_key :photo
      integer :position, :default => 1
    end
  end

  def self.down
    drop_table :attachments
  end
end
