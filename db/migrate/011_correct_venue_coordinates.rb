class CorrectVenueCoordinates < ActiveRecord::Migration
  # IDIOT. Read the documentation.
  
  def self.up
    execute "ALTER TABLE venues MODIFY latitude DECIMAL(20,16);"
    execute "ALTER TABLE venues MODIFY longitude DECIMAL(20,16);"
  end

  def self.down
  end
end
