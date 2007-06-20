class CreateShows < ActiveRecord::Migration
  def self.up
    create_table :shows do |t|
      string :name, :null => false
      string :permalink, :null => false
      integer :year
      integer :month
      text :description
      boolean :is_current
      text :splash_page
      
      timestamps!
    end
  end

  def self.down
    drop_table :shows
  end
end
