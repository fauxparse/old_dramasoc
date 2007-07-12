class Post < ActiveRecord::Base
  belongs_to :user
  has_permalink :date_and_title
  
  validates_presence_of :title
  
  def to_param; permalink; end
  
  def date_and_title
    created_at.strftime("%Y-%m-%d ") + title
  end
  
  class << self
    def per_page; 10; end
    
    def most_recent(n = 1)
      find :all, :order => "posts.created_at DESC", :limit => n, :include => :user
    end
  end
end
