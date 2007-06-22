require 'digest/sha1'

class User < Member
  #include AuthenticatedBase

  validates_uniqueness_of :login, :case_sensitive => false
end
