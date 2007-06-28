class AddBookingCutoff < ActiveRecord::Migration
  def self.up
    add_column :shows, :auto_cutoff, :integer, :default => 3
    add_column :performances, :bookings_open, :boolean, :default => true
  end

  def self.down
    remove_column :performances, :bookings_open
    remove_column :shows, :auto_cutoff
  end
end
