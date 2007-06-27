class Role < ActiveRecord::Base
  belongs_to :show
  belongs_to :member
  acts_as_list :scope => :show
  
  attr_accessor :name
  
  alias_attribute :character, :role
  
  validates_presence_of :member_id, :if => Proc.new { |role| !role.name.blank? }
  validates_presence_of :role
  
  before_validation :get_member_by_name
  
  DisplayOrder = [ :production, :acting, :crew ]
  
  def <=>(other)
    if self.class == other.class
      position <=> other.position
    else
      a, b = [ self, other ].collect { |r| DisplayOrder.index(r.role_type) }
      a <=> b
    end
  end
  
  def get_member_by_name
    if !@name.blank?
      m = Member.find_or_create_by_name @name
      write_attribute :member_id, m.id unless m.nil?
    end
  end
  
  def type=(t)
    write_attribute :type, t
  end
  
  def role_type; :acting; end
end
