# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def bc(text)
    BlueCloth.new(text || "").to_html
  end  
end
