class BookingsController < ApplicationController

  before_filter :login_required, :only => [ :index, :edit, :update, :destroy, :list ]
  before_filter :get_show, :except => [ :show ]
  before_filter :get_booking, :only => [ :show, :edit, :update, :destroy ]

protected
  def get_show
    @show = Show.find_by_permalink(params[:show_id]) or raise ActiveRecord::RecordNotFound
  end
  
  def get_booking
    @booking = Booking.find(params[:id]) or raise ActiveRecord::RecordNotFound
  end
  
public
  def index
    @bookings = @show.bookings.find :all
  end

  def show
    respond_to do |wants|
      wants.html { render }
      wants.ics do
        cal = Icalendar::Calendar.new
        e = @booking.performance.to_ical
        e.url = show_path(@booking.performance.show_id)
        cal.add e
        render :text => cal.to_ical, :layout => false
      end
    end
  end

  def new
    @booking = Booking.new params[:booking]
    @booking.performance = @show.next_performance if !@show.next_performance.nil? and @booking.performance.nil?
  end

  def create
    @booking = Booking.new params[:booking]
    if @booking.save
      tickets = (t = @booking.total_tickets) == 1 ? "1 ticket" : "#{t} tickets"
      flash[:notice] = "You have booked #{tickets} for <cite>#{@show}</cite> on #{@booking.performance.strftime}. This booking will be confirmed by email. Thanks, and enjoy the show! (<a href=\"/bookings/#{@booking.id}.ics\">Add to iCal</a>)"
      
      Postman.deliver_booking_request @booking
      Postman.deliver_booking_confirmation @booking if !@booking.email.blank?
      Postman.deliver_information_request @booking.name, @booking.email, @booking.comments, true if @booking.notify_me
      
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
      # TODO: Redirect to bookings for this performance instead of for the show
      redirect_to show_bookings_path(@show)
    else
      render :action => "edit"
    end
  end

  def destroy
  end
  
  def list
    if params[:performance_id]
      @performance = Performance.find params[:performance_id], :include => :bookings
    else
      @performances = @show.performances.find :all
    end
  end
end
