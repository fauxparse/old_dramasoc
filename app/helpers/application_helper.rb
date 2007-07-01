# Methods added to this helper will be available to all templates in the application.

module ApplicationHelper
  def bc(text)
    BlueCloth.new(text || "").to_html
  end
  
  def error_messages_for(*params)
    options = params.last.is_a?(Hash) ? params.pop.symbolize_keys : {}
    objects = params.collect {|object_name| instance_variable_get("@#{object_name}") }.compact
    count   = objects.inject(0) {|sum, object| sum + object.errors.count }
    unless count.zero?
      html = {}
      [:id, :class].each do |key|
        if options.include?(key)
          value = options[key]
          html[key] = value unless value.blank?
        else
          html[key] = 'errors'
        end
      end
      header_message = options[:title] || "#{pluralize(count, 'error')} prohibited this #{(options[:object_name] || params.first).to_s.gsub('_', ' ')} from being saved"
      error_messages = objects.map {|object| object.errors.full_messages.map {|msg| content_tag(:li, msg) } }
      content_tag(:div,
      content_tag(options[:header_tag] || :h2, header_message) <<
      content_tag(:p, 'There were problems with the following fields:') <<
      content_tag(:ul, error_messages),
      html
      )
    else
      ''
    end
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
  
  def tabbed_form_for(object_name, tab_id, *args, &proc)
    raise ArgumentError, "Missing block" unless block_given?
    options = args.last.is_a?(Hash) ? args.pop : {}
    html_options = (options.delete(:html) || {}).stringify_keys
    html_options["id"] ||= "fields_#{tab_id}"
    html_options["class"] ||= "tabbed"
    html_options["style"] ||= "display: none;" unless @default_tab.to_s == tab_id.to_s
    concat(form_tag(options.delete(:url) || {}, html_options), proc.binding)
    concat(hidden_field_tag("active_tab", tab_id.to_s), proc.binding)
    fields_for(object_name, *(args << options), &proc)
    concat('</form>', proc.binding)
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

module Enumerable
  def split_by(method, order = :none)
    h = Hash.new { |h, k| h[k] = [] }
    each { |element| h[element.send(method)] << element }
    if block_given?
      group_keys = h.keys.sort
      group_keys.reverse! unless order == :ascending
      group_keys.each { |k| yield [ k, h[k] ] }
    else
      return h
    end
  end
end
