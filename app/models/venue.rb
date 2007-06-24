class Venue < ActiveRecord::Base
  has_many :shows
  has_many :performances, :through => :shows
  
  def to_s; name; end
end
