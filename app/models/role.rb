class Role < ActiveRecord::Base
  belongs_to :show
  belongs_to :member
  acts_as_list :scope => :show
  
  DisplayOrder = [ :production, :actor, :crew ]
  
  def <=>(other)
    if self.class == other.class
      position <=> other.position
    else
      a, b = [ self, other ].collect { |r| DisplayOrder.index(r.my_type) }
      a <=> b
    end
  end
  
  def my_type; :actor; end
end
