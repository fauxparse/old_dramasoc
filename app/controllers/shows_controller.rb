class ShowsController < ApplicationController
  before_filter :set_active_tab
  before_filter :login_required, :only => [ :new, :create, :edit, :update, :destroy ]
  before_filter :get_show, :only => [ :edit, :update, :destroy ]

protected
  def set_active_tab
    @active_tab = :shows
  end

  def get_show
    @show = Show.find_by_permalink(params[:id]) or raise ActiveRecord::RecordNotFound
  end

public
  def index
    @shows = Show.find :all, :order => "year DESC, month DESC", :conditions => "parent_id IS NULL"
  end

  def show
    @show = Show.find_by_permalink(params[:id], :include => [ :performances, :venue, { :roles => :member } ]) or raise ActiveRecord::RecordNotFound
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
    @default_tab = params[:active_tab].to_sym if params[:active_tab]
  end

  def update
    @default_tab = params[:active_tab].to_sym if params[:active_tab]
    if @show.update_attributes params[:show]
      flash[:notice] = "Show details updated successfully"
      redirect_to :action => :edit
    else
      render :action => :edit
    end
  end

  def destroy
  end
end
