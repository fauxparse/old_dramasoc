class StandardiseRoles < ActiveRecord::Migration
  def self.up
    remove_column :roles, :job
    remove_column :roles, :character
    add_column :roles, :role, :string
  end

  def self.down
    add_column :roles, :job, :string
    add_column :roles, :character, :string
    remove_column :roles, :role
  end
end
