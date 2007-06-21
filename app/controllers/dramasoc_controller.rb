class DramasocController < ApplicationController

  def home
    @active_tab = :home
  end

  def about
    @active_tab = :about
  end
  
  def get_involved
    @active_tab = :get_involved
  end
end
