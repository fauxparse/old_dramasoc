require 'icalendar'

class EventsController < ApplicationController

  def index
    @events = Event.find :all, :order => "events.starts_at DESC"
    respond_to do |wants|
      wants.html { render }
      wants.ics do
        cal = Icalendar::Calendar.new
        @events.each do |event|
          e = event.to_ical
          e.url = event_path(event)
          cal.add e
        end
        render :text => cal.to_ical, :layout => false
      end
    end
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
