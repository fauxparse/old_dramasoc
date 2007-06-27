class ProductionRole < Role
  def role_type; :production; end

  alias_attribute :job, :role
end
