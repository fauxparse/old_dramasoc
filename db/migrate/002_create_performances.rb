class CreatePerformances < ActiveRecord::Migration
  def self.up
    create_table :performances do |t|
      datetime :time
      foreign_key :show
    end
  end

  def self.down
    drop_table :performances
  end
end
