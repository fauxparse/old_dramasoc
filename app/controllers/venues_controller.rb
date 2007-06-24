class VenuesController < ApplicationController

  def index
  end

  def show
  end

  def print
  end

  def new
    @venue = Venue.new
    render :layout => !request.xhr?
  end

  def create
  end

  def edit
    @venue = Venue.find(params[:id]) or raise ActiveRecord::RecordNotFound
    render :layout => !request.xhr?
  end

  def update
  end

  def destroy
  end
end
