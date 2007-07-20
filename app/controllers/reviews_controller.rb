class ReviewsController < ApplicationController
  before_filter :get_show
  before_filter :get_review, :only => [ :show, :edit, :update, :destroy ]

protected
  def get_show
    @show = Show.find_by_permalink(params[:show_id]) or raise ActiveRecord::RecordNotFound
  end

  def get_review
    @review = Review.find(params[:id]) or raise ActiveRecord::RecordNotFound
  end

public
  def index
    @reviews = @show.reviews.find :all
  end

  def show
  end

  def new
    @review = Review.new
  end

  def create
    @review = @show.reviews.create params[:review]
    if @review.valid?
      flash[:notice] = "Review created successfully"
      redirect_to show_reviews_path(@show)
    else
      render :action => :edit
    end
  end

  def edit
  end

  def update
    if @review.update_attributes params[:review]
      flash[:notice] = "Review updated successfully"
      redirect_to show_review_path(@show, @review)
    else
      render :action => :edit
    end
  end

  def destroy
    @review.destroy
    flash[:notice] = "Review deleted"
    redirect_to show_reviews_path(@show)
  end
end
