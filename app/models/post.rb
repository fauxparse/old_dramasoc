class Post < ActiveRecord::Base
  belongs_to :user
  
  class << self
    def per_page; 10; end
    
    def most_recent(n = 1)
      find :all, :order => "posts.created_at DESC", :limit => n, :include => :user
    end
  end
end
