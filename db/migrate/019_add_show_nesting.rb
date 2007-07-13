class AddShowNesting < ActiveRecord::Migration
  def self.up
    add_column :shows, :parent_id, :integer
    add_column :shows, :position, :integer, :default => 1
    add_column :shows, :children_count, :integer, :default => 0
  end

  def self.down
    remove_column :shows, :parent_id
    remove_column :shows, :position
    remove_column :shows, :children_count
  end
end
