class Photo < ActiveRecord::Base
  has_attachment :storage => :file_system, :max_size => 1.megabytes, :thumbnails => { :thumb => '80x80>', :tiny => '40x40>' }, :processor => :ImageScience, :resize_to => '600x600>'
  
  validates_as_attachment
end
