class Performance < ActiveRecord::Base
  belongs_to :show
  has_many :bookings # Hopefully! ;)
  validates_uniqueness_of :time, :scope => :show_id
  
  def <=>(another)
    time <=> another.time
  end
  
  def date
    time.to_date
  end
  
  def strftime(fmt = "%A, %e %B at %l:%M%p")
    time.strftime fmt
  end
  
  def to_option(fmt = "%A, %e %B at %l:%M%p")
    fmt << " (CLOSED)" if !bookings_open?
    strftime fmt
  end
  
  def bookings_open?
    bookings_open and show.bookings_open? and !(show.auto_cutoff_enabled? and Time.now > (time - show.auto_cutoff.hours))
  end
  
  def to_ical
    # TODO: Cache icalendar uids in the event model
    e = Icalendar::Event.new
    e.start = time.to_date_time
    e.end = (time + 2.hours).to_date_time
    e.summary = show.name
    e.location = show.venue.to_s unless show.venue.nil?
    e
  end
end
