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
end

class Time
  def to_date_time
    DateTime.strptime(to_s, '%a %b %d %H:%M:%S %Z %Y')
  end
end