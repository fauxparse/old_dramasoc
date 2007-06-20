require 'fuzzy_dates'

class Show < ActiveRecord::Base
  composed_of :date, :class_name => "FuzzyDate", :mapping => %w(year month)
  has_permalink :name_and_date
  
  has_many :roles, :order => "position ASC"
  has_many :production_roles, :class_name => "ProductionRole", :conditions => "roles.type = 'ProductionRole'", :order => "position ASC"
  has_many :acting_roles, :class_name => "Role", :conditions => "roles.type IS NULL", :order => "position ASC"
  has_many :crew_roles, :class_name => "CrewRole", :conditions => "roles.type = 'CrewRole'", :order => "position ASC"
  
  has_many :members, :through => :roles, :uniq => true
  has_many :performances, :order => "time ASC"
  has_many :bookings, :through => :performances
  
  validates_presence_of :name
  
  def <=>(other_show)
    date <=> other_show.date
  end
  
  def name_and_date
    "#{name} (#{date.year})"
  end
  
  def to_s
    name
  end
  
  def to_param
    permalink
  end
  
  def bookings_open?
    !performances.empty? and performances.last.date >= Date.today
  end
  
  def next_performance
    (p = performances.select { |p| p.date >= Date.today }).empty? ? nil : p.first
  end
  
  class << self
    def current
      find :first, :conditions => [ "is_current = ?", true ], :order => "year DESC, month DESC"
    end
  end
end
