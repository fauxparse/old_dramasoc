require 'digest/sha1'

class User < Member
  include AuthenticatedBase
  set_table_name "members" # Don't know why I need this!

  validates_uniqueness_of :login, :case_sensitive => false
end
