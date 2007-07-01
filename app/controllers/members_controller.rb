class MembersController < ApplicationController
  before_filter :get_member, :only => [ :edit, :update, :destroy ]

protected
  def set_active_tab
    @active_tab = :members
  end

  def get_member
    @member = Member.find(params[:id]) or raise ActiveRecord::RecordNotFound
  end

public
  def index
  end

  def show
    @member = Member.find(params[:id], :include => [ :shows ]) or raise ActiveRecord::RecordNotFound
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
