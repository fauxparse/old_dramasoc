class CreateReviews < ActiveRecord::Migration
  def self.up
    create_table :reviews do |t|
      foreign_key :show
      string :title
      string :publication
      string :reviewer
      date :date
      text :body
      text :more
      text :pullquote
    end
  end

  def self.down
    drop_table :reviews
  end
end
