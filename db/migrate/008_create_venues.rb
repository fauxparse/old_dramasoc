class CreateVenues < ActiveRecord::Migration
  def self.up
    create_table :venues do |t|
      string :name
      text :description
      text :address
      decimal :latitude, :precision => 16
      decimal :longitude, :precision => 16
    end
  end

  def self.down
    drop_table :venues
  end
end
