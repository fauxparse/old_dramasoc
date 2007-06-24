module Mapping
  @@engine = :google
  @@engines = {}
  
  def engine; @@engine; end
    
  def engine=(e)
    if api_keys.has_key? e
      @@engine = e
    else
      raise IndexError, "map engine does not exist"
    end
  end
    
  def api_keys
    @@api_keys ||= YAML.load_file('config/map_api_keys.yml').with_indifferent_access
  end
  
  def api_key(host = 'localhost')
    #host = 'localhost' if host.blank?
    api_keys[@@engine][host]
  end
end
