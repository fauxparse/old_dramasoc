class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      string :title
      text :description
      string :location
      datetime :starts_at
    end
  end

  def self.down
    drop_table :events
  end
end
