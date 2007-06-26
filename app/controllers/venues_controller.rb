class VenuesController < ApplicationController
  before_filter :get_venue, :only => [ :show, :edit, :update, :destroy ]

protected
  def get_venue
    @venue = Venue.find(params[:id]) or raise ActiveRecord::RecordNotFound
  end

public
  def index
  end

  def show
  end

  def print
  end

  def new
    @venue = Venue.new :latitude => params[:latitude], :longitude => params[:longitude]
    render :layout => !request.xhr?
  end

  def create
    @venue = Venue.create params[:venue]
    respond_to do |wants|
      wants.js
    end
  end

  def edit
    render :layout => !request.xhr?
  end

  def update
    v = params[:venue] || {}
    v[:latitude] = params[:latitude] if params[:latitude]
    v[:longitude] = params[:longitude] if params[:longitude]
    @venue.update_attributes v
    respond_to do |wants|
      wants.js { render :nothing => true }
    end
  end

  def destroy
  end
end
