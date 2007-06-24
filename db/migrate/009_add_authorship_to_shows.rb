class AddAuthorshipToShows < ActiveRecord::Migration
  def self.up
    add_column :shows, :author, :string
  end

  def self.down
    remove_column :shows, :author
  end
end
