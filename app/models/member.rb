class Member < ActiveRecord::Base
  include AuthenticatedBase

  has_many :roles
  has_many :shows, :through => :roles, :uniq => true
  
  def to_s; name; end
  
  def name
    [ first_name, last_name ].compact.join(' ')
  end
end
