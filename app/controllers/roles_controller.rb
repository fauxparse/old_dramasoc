class RolesController < ApplicationController
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
    @role = @show.roles.create params[:role]
    if !params[:role][:type].blank?
      @role.update_attribute :type, params[:role][:type]
      @role = Role.find @role.id # Reload with correct class
    end
    respond_to do |wants|
      wants.js
    end
  end

  def edit
  end

  def update
  end

  def destroy
    @show.roles.destroy params[:id]
    respond_to do |wants|
      wants.js { render :nothing => true }
    end
  end
end
