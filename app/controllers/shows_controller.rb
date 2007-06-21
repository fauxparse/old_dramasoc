class ShowsController < ApplicationController
  before_filter :set_active_tab
  before_filter :get_show, :only => [ :show, :edit, :update, :destroy ]

protected
  def set_active_tab
    @active_tab = :shows
  end

  def get_show
    @show = Show.find_by_permalink(params[:id]) or raise ActiveRecord::RecordNotFound
  end

public
  def index
    @shows = Show.find :all, :order => "year DESC, month DESC"
  end

  def show
  end

  def current
    @show = Show.current
    if @show.nil? or @show.splash_page.nil?
      redirect_to "/dramasoc/" and return false
    else
      render :inline => @show.splash_page
    end
  end

  def new
    @show = Show.new :year => Date.today.year
  end

  def create
    @show = Show.new params[:show]
    if @show.save
      flash[:notice] = "Show created successfully"
      redirect_to show_path(@show)
    else
      render :action => "new"
    end
  end

  def edit
  end

  def update
    if @show.update_attributes params[:show]
      flash[:notice] = "Show details updated successfully"
      redirect_to show_path(@show)
    else
      render :action => :edit
    end
  end

  def destroy
  end
end
