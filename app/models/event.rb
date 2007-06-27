require 'icalendar'

class Event < ActiveRecord::Base
  
  def to_ical
    # TODO: Cache icalendar uids in the event model
    e = Icalendar::Event.new
    e.start = starts_at.to_date_time
    e.end = (starts_at + 1.hour).to_date_time
    e.summary = title
    e.location = location unless location.nil?
    e
  end
  
  class << self
    def upcoming(n = 5)
      find :all, :conditions => [ "DATE(starts_at) >= ?", Date.today ], :order => "starts_at ASC", :limit => n
    end
  end
end
