class BookingsController < ApplicationController

  before_filter :get_show
  before_filter :get_booking, :only => [ :show, :edit, :update, :destroy ]

protected
  def get_show
    @show = Show.find_by_permalink(params[:show_id]) or raise ActiveRecord::RecordNotFound
  end
  
public
  def index
    @bookings = @show.bookings.find :all
  end

  def show
  end

  def new
    @booking = Booking.new params[:booking]
  end

  def create
    @booking = Booking.new params[:booking]
    if @booking.save
      # TODO: Send email to bookings@dramasoc.org
      # TODO: Send email to user
      tickets = (t = @booking.total_tickets) == 1 ? "1 ticket" : "#{t} tickets"
      flash[:notice] = "You have booked #{tickets} for <cite>#{@show}</cite> on #{@booking.performance.strftime}. This booking will be confirmed by email. Thanks, and enjoy the show!"
      redirect_to show_path(@show)
    else
      render :action => "new"
    end
  end

  def edit
  end

  def update
    if @booking.update_attributes params[:booking]
      flash[:notice] = "Booking successfully updated"
      # TODO: Redirect to bookings for this performance
      redirect_to show_bookings_path(@show)
    else
      render :action => "edit"
    end
  end

  def destroy
  end
end
