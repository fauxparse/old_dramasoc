class Review < ActiveRecord::Base
  belongs_to :show
  
  def to_s; title; end
end
