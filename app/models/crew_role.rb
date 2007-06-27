class CrewRole < Role
  def role_type; :crew; end

  alias_attribute :job, :role
end
