# Methods added to this helper will be available to all templates in the application.

module ApplicationHelper
  def bc(text)
    BlueCloth.new(text || "").to_html
  end
end

module ActionView
  module Helpers
    module UrlHelper
      def augment_link_options(name, options, html_options)
        html_options[:onclick] = "popup_login_redbox(this); return false;"
        [ name, options, html_options ]
      end
    end
  end
end

