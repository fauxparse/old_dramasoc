class Member < ActiveRecord::Base
  has_many :roles
  has_many :shows, :through => :roles, :uniq => true
  
  def to_s; name; end
  
  def name
    [ first_name, last_name ].compact.join(' ')
  end
  
  def <=>(another)
    if (v = last_name.casecmp(another.last_name)) == 0
      v = first_name.casecmp(another.first_name)
    end
    v
  end
  
  class << self
    def full_name_to_first_and_last_names(name)
      words = name.split(' ')
      [ words.shift, words.join(' ') ]
    end
    
    def find_or_create_by_name(name)
      first_name, last_name = full_name_to_first_and_last_names(name)
      find_or_create_by_first_name_and_last_name first_name, last_name
    end
  end
end
