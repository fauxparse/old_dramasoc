class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      string :first_name
      string :last_name
      string :email
    end
  end

  def self.down
    drop_table :members
  end
end
