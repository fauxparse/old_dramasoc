class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      foreign_key :member
      foreign_key :show
      string :job
      string :character
      integer :position, :default => 0
      inheritable
    end
  end

  def self.down
    drop_table :roles
  end
end
