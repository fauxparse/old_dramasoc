require 'fuzzy_dates'

class Show < ActiveRecord::Base
  composed_of :date, :class_name => "FuzzyDate", :mapping => [ %w(year year), %w(month month) ]
  has_permalink :name_and_date
  
  has_many :roles, :order => "position ASC"
  has_many :production_roles, :class_name => "ProductionRole", :conditions => "roles.type = 'ProductionRole'", :order => "position ASC"
  has_many :acting_roles, :class_name => "Role", :conditions => "roles.type IS NULL", :order => "position ASC"
  has_many :crew_roles, :class_name => "CrewRole", :conditions => "roles.type = 'CrewRole'", :order => "position ASC"
  has_many :members, :through => :roles, :uniq => true
  has_many :performances, :order => "time ASC"
  has_many :bookings, :through => :performances
  belongs_to :venue
  has_many :attachments, :as => :attachable, :order => "position ASC"
  has_many :photos, :through => :attachments
  has_many :reviews, :order => "reviews.date DESC"
  
  acts_as_tree :order => :position

  attr_accessor :auto_cutoff_enabled
  
  validates_presence_of :name
  validates_presence_of :year
  
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
    bookings_open and !performances.empty? and !(performances.select(&:bookings_open)).empty? and performances.last.date >= Date.today and !booking_email.blank?
  end
  
  def auto_cutoff_enabled
    !read_attribute('auto_cutoff').nil?
  end
  
  alias_method :auto_cutoff_enabled?, :auto_cutoff_enabled

  def auto_cutoff_enabled=(value)
    write_attribute 'auto_cutoff', nil if [ false, "0", 0 ].include? value
  end
  
  def performance_dates
    performances.collect(&:date).sort
  end
  
  def performance_dates_as_string
    first, last = performance_dates.first, performance_dates.last
    if first == last
      first.strftime('%e %B, %Y')
    elsif first.month == last.month
      first.strftime('%e') + ' &ndash; ' + last.strftime('%e %B, %Y')
    elsif first.year == last.year
      first.strftime('%e %B') + ' &ndash; ' + last.strftime('%e %B, %Y')
    else
      first.strftime('%e %B, %Y') + ' &ndash; ' + last.strftime('%e %B, %Y')
    end
  end
  
  def next_performance
    (p = performances.select { |p| p.date >= Date.today and p.bookings_open? }).empty? ? nil : p.first
  end
  
  class << self
    def current
      find :first, :conditions => [ "is_current = ?", true ], :order => "year DESC, month DESC"
    end
    
    def most_recent(n = 3)
      find :all, :order => "year DESC, month DESC", :limit => n
    end
  end
end
