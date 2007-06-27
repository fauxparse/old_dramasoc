class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      foreign_key :user
      string :title
      text :body
      text :more
      timestamps!
    end
  end

  def self.down
    drop_table :posts
  end
end
