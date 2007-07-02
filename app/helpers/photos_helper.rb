module PhotosHelper
  def attachable_photos_path(attachable)
    if attachable.nil?
      photos_path
    else
      method_name = "#{attachable.class.table_name.singularize}_photos_path"
      send method_name, attachable
    end
  end
end
