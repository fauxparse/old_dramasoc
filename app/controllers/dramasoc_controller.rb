class DramasocController < ApplicationController

  def home
    @active_tab = :home
    @events = Event.upcoming(3)
    @news = []
    @shows = Show.most_recent(3)
  end

  def about
    @active_tab = :about
  end
  
  def get_involved
    @active_tab = :get_involved
  end
end
