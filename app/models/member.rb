class Member < ActiveRecord::Base
  has_many :roles, :include => :show
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
  
  def production_roles
    @production_roles ||= role_group :production
  end
  
  def acting_roles
    @acting_roles ||= role_group :acting
  end
  
  def crew_roles
    @crew_roles ||= role_group :crew
  end
  
  def role_group(group)
    h = Hash.new { |h, k| h[k] = [] }
    roles.each { |r| h[r.show] << r.role if r.role_type == group }
    h
  end
  
  class << self
    def full_name_to_first_and_last_names(name)
      words = name.split(' ')
      [ words.pop, words.join(' ') ].reverse.collect { |w| w.gsub(/_/, ' ') }
    end
    
    def find_or_create_by_name(name)
      first_name, last_name = full_name_to_first_and_last_names(name)
      find_or_create_by_first_name_and_last_name first_name, last_name
    end
  end
end
