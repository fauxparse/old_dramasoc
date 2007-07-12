class NewsController < ApplicationController
  before_filter :login_required, :only => [ :new, :create, :edit, :update, :destroy ]
  before_filter :get_post, :only => [ :show, :edit, :update, :destroy ]

protected
  def get_post
    @post = Post.find_by_permalink(params[:id]) or raise ActiveRecord::RecordNotFound
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
    @post = current_user.posts.create params[:post]
    if @post.valid?
      flash[:notice] = "News posted successfully"
      redirect_to news_path
    else
      render :action => :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
