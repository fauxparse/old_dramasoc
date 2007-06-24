class CreateVenues < ActiveRecord::Migration
  def self.up
    create_table :venues do |t|
      string :name
      text :description
      text :address
      decimal :latitude, :precision => 16
      decimal :longitude, :precision => 16
    end
    
    add_column :shows, :venue_id, :integer
    execute 'ALTER TABLE shows ADD CONSTRAINT fk_venue_id FOREIGN KEY (venue_id) REFERENCES venues(id)'
  end

  def self.down
    execute 'ALTER TABLE shows DROP CONSTRAINT fk_venue_id'
    remove_column :shows, :venue_id
    drop_table :venues
  end
end
