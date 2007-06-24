# Methods added to this helper will be available to all templates in the application.

include Mapping

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
  
  def google_maps_javascript_link
    "<script type=\"text/javascript\" src=\"http://maps.google.com/maps?file=api&amp;v=2&amp;key=#{Mapping.api_key(request.params['SERVER_NAME'])}\"></script>"
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

