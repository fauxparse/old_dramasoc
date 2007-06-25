class Venue < ActiveRecord::Base
  has_many :shows
  has_many :performances, :through => :shows
  
  def to_s; name; end
  
  def has_coordinates?
    !latitude.nil? and !longitude.nil?
  end
  
  def coordinates
    [ latitude, longitude ]
  end
end
