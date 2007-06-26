# Methods added to this helper will be available to all templates in the application.

module ApplicationHelper
  def bc(text)
    BlueCloth.new(text || "").to_html
  end
  
  def tabbed_fieldset(name, options = {}, &block)
    html_options = options.stringify_keys
    html_options["id"] ||= "fields_#{name}"
    html_options["class"] ||= "tabbed"
    html_options["style"] = ('display: none; ' + (html_options["style"] || "")) unless @default_tab.to_s == name.to_s
    
    if block_given?
      content = capture(&block)
      concat(tag(:fieldset, html_options, true), block.binding)
      concat(content, block.binding)
      concat("</fieldset>", block.binding)
    else
      tag(:fieldset, html_options, true)
    end
  end
  
  def google_map(name = "map", venues = [], options = {})
    map = GMap.new(name)
    map.control_init(options[:controls] || { :large_map => true, :map_type => true })
    map.center_zoom_init(venues.empty? ? [ -43.524, 172.58 ] : venues.first.coordinates, 13)
    venues.select(&:has_coordinates?).each do |venue|
      marker = init_marker map, venue, options
    end
    
    map.event_init(map, 'click', "function(marker, point) { if (point) { #{options[:point_clicked]}(point); } }") if options[:point_clicked]

    map
  end
  
  def init_marker(map, venue, options)
    marker = GMarker.new(venue.coordinates, :title => venue.name, :info_window => render(:partial => "venues/info_window", :locals => { :venue => venue }), :draggable => !options[:marker_dragged].nil?, :name => venue.id.to_s)
    map.overlay_global_init(marker, "markers[#{venue.id}]")
    map.event_global_init(marker, 'dragend', "function() { #{options[:marker_dragged]}(markers[#{venue.id}]) }") unless options[:marker_dragged].nil?
    map.event_global_init(marker, 'click', "function() { #{options[:marker_clicked]}(markers[#{venue.id}]) }") unless options[:marker_clicked].nil?
    marker
  end
end

module ActionView
  module Helpers
    module UrlHelper
      def augment_link_options(name, options, html_options)
        html_options ||= {}
        html_options[:class] = [ html_options[:class], "login-required" ].compact.join ' '
        html_options[:onclick] = "popup_login_redbox(this); return false;"
        [ name, options, html_options ]
      end
    end
  end
end

