class PerformancesController < ApplicationController
  before_filter :login_required, :only => [ :new, :create, :edit, :update, :destroy ]
  before_filter :get_show

protected
  def get_show
    @show = Show.find_by_permalink(params[:show_id]) or raise ActiveRecord::RecordNotFound
  end

public
  def index
  end

  def show
  end

  def new
  end

  def create
    @performance = @show.performances.create params[:performance]
    respond_to do |wants|
      wants.js
    end
  end

  def edit
  end

  def update
  end

  def destroy
    @performance = @show.performances.find params[:id]
    @performance.destroy
    respond_to do |wants|
      wants.js
    end
  end
  
  def open
    @performance = @show.performances.find params[:id]
    @performance.update_attribute :bookings_open, params[:state]
    respond_to do |wants|
      wants.js { render :nothing => true }
    end
  end
end
