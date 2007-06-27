class RolesController < ApplicationController
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
  
  def reorder
    [ :production_roles, :acting_roles, :crew_roles ].each do |role_set|
      params[role_set].each_with_index { |rid, p| Role.update(rid, :position => p + 1) } if params[role_set]
    end
    respond_to do |wants|
      wants.js { render :nothing => true }
    end
  end
end
