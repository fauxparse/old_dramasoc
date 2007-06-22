class CreateUsers < ActiveRecord::Migration
  def self.up
    add_column :members, :type, :string # Make inheritable
    add_column :members, :login, :string
    add_column :members, :crypted_password, :string, :limit => 40
    add_column :members, :salt, :string, :limit => 40
    add_column :members, :created_at, :datetime
    add_column :members, :updated_at, :datetime
    add_column :members, :last_login_at, :datetime
    add_column :members, :remember_token, :string
    add_column :members, :remember_token_expires_at, :datetime
    add_column :members, :visits_count, :integer, :default => 0
    add_column :members, :time_zone, :string, :default => 'Etc/UTC'
  end

  def self.down
    remove_column :members, :type
    remove_column :members, :login
    remove_column :members, :crypted_password
    remove_column :members, :salt, :string
    remove_column :members, :created_at
    remove_column :members, :updated_at
    remove_column :members, :last_login_at
    remove_column :members, :remember_token
    remove_column :members, :remember_token_expires_at
    remove_column :members, :visits_count
    remove_column :members, :time_zone
  end
end
