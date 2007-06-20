class Performance < ActiveRecord::Base
  belongs_to :show
  has_many :bookings # Hopefully! ;)
  validates_uniqueness_of :time, :scope => :show_id
  
  def date
    time.to_date
  end
  
  def strftime(fmt = "%A, %e %B at %l:%M%p")
    time.strftime fmt
  end
end
