class Performance < ActiveRecord::Base
  belongs_to :show
  has_many :bookings # Hopefully! ;)
  validates_uniqueness_of :time, :scope => :show_id
  
  def date
    time.to_date
  end
  
  def strftime(fmt = "%A, %e %B at %l:%M%p")
    time.strftime fmt
  end
  
  def to_ical
    # TODO: Cache icalendar uids in the event model
    e = Icalendar::Event.new
    e.start = time.to_date_time
    e.end = (time + 2.hours).to_date_time
    e.summary = show.name
    # TODO: Show location
    #e.location = location unless location.nil?
    e
  end
end
