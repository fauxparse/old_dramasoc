class UsersController < ApplicationController
  before_filter :login_required, :except => [ :index, :show ]

  def index
  end

  def show
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
