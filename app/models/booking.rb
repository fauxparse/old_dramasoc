class Booking < ActiveRecord::Base
  belongs_to :performance, :include => :show
  
  validates_presence_of :name
  validates_presence_of :performance_id
  validates_presence_of :phone, :message => "or email must be supplied", :if => Proc.new { |booking| booking.email.blank? }
  validates_numericality_of :waged, :if => Proc.new { |b| !b.waged.blank? }
  validates_numericality_of :unwaged, :if => Proc.new { |b| !b.unwaged.blank? }
  validates_each :waged do |r, a, v|
    if (r.waged || 0).to_i + (r.unwaged || 0).to_i <= 0 then
      r.errors.add a, 'or unwaged must be at least 1'
    end
  end
  
  def show
    performance.show
  end

  def waged_tickets
    waged || 0
  end
  
  def unwaged_tickets
    unwaged || 0
  end
  
  def total_tickets
    waged_tickets + unwaged_tickets
  end
  
  def total_price
    waged_tickets.to_f * show.waged_price + unwaged_tickets.to_f * show.unwaged_price
  end
  
  def tickets
    [ :waged, :unwaged ].collect { |w| (t = send(w)).zero? ? nil : ("#{t} #{w} " + (t == 1 ? "ticket" : "tickets")) }.compact.join(' and ')
  end
end
