class AddBookingDetailsToShows < ActiveRecord::Migration
  def self.up
    add_column :shows, :bookings_open, :boolean, :default => false
    add_column :shows, :booking_email, :string
  end

  def self.down
    remove_column :shows, :booking_email
    remove_column :shows, :bookings_open
  end
end
