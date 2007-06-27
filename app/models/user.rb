class User < Member
  include AuthenticatedBase
  
  set_table_name "members"

  validates_uniqueness_of :login, :case_sensitive => false
end
