class CreateBookings < ActiveRecord::Migration
  def self.up
    add_column :shows, :waged_price, :decimal, :precision => 2
    add_column :shows, :unwaged_price, :decimal, :precision => 2
    
    create_table :bookings do |t|
      foreign_key :performance
      string :name
      string :phone
      string :email
      integer :waged, :default => 2
      integer :unwaged, :default => 0
      boolean :notify_me
      boolean :confirmed, :default => false
      text :comments
    end
  end

  def self.down
    drop_table :bookings
    remove_column :shows, :waged_price
    remove_column :shows, :unwaged_price
  end
end
