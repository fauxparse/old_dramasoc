class Attachment < ActiveRecord::Base
  belongs_to :attachable, :polymorphic => true
  belongs_to :photo
  acts_as_list :scope => 'attachable_id = #{quote_value attachable_id} AND attachable_type = #{quote_value attachable_type}'
end
