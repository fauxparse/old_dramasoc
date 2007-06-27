class NewsController < ApplicationController
  before_filter :login_required, :only => [ :new, :create, :edit, :update, :destroy ]
  before_filter :get_post, :only => [ :show, :edit, :update, :destroy ]

protected
  def get_post
    @post = Post.find(params[:id]) or raise ActiveRecord::RecordNotFound
  end

public
  def index
    #@posts = Post.find :all, :include => :user, :order => "posts.created_at DESC"
    @posts = Post.paginate :page => params[:page], :include => :user, :order => "posts.created_at DESC"
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
