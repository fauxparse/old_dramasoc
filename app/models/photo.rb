class Photo < ActiveRecord::Base
protected
  def self.processor
    begin
      options = YAML::load_file 'config/site_options.yml'
      options['photos']['processor']
    rescue Errno::ENOENT, IndexError
      :imageScience
    end
  end
  
public
  
  has_attachment :storage => :file_system, :max_size => 1.megabytes, :thumbnails => { :thumb => '80x80>', :tiny => '40x40>' }, :processor => processor, :resize_to => '600x600>'
  
  validates_as_attachment
  

end
