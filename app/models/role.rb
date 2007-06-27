class Role < ActiveRecord::Base
  belongs_to :show
  belongs_to :member
  acts_as_list :scope => :show
  
  attr_accessor :name
  
  alias_attribute :character, :role
  
  validates_presence_of :member_id, :if => Proc.new { |role| !role.name.blank? }
  validates_presence_of :role
  
  before_validation :get_member_by_name
  after_destroy :delete_unused_members
  
  DisplayOrder = [ :production, :acting, :crew ]
  
  def <=>(other)
    if self.class == other.class
      position <=> other.position
    else
      a, b = [ self, other ].collect { |r| DisplayOrder.index(r.role_type) }
      a <=> b
    end
  end
  
  def type=(t)
    write_attribute :type, t
  end
  
  def role_type; :acting; end
  
protected
  # Convert a name to a user, creating if necessary.
  def get_member_by_name
    if !@name.blank?
      m = Member.find_or_create_by_name @name
      write_attribute :member_id, m.id unless m.nil?
    end
  end

  # Delete associated members if they're not in any shows and
  # don't need to log in to the system.
  def delete_unused_members
    if !member.is_a?(User) and member.roles(:true).empty?
      member.destroy
    end
  end
end
