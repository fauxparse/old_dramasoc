require 'fuzzy_dates'

class Show < ActiveRecord::Base
  composed_of :date, :class_name => "FuzzyDate", :mapping => %w(year month)
  has_permalink :name_and_date
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
