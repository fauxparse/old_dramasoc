# Methods added to this helper will be available to all templates in the application.

module ApplicationHelper
  def bc(text)
    BlueCloth.new(text || "").to_html
  end
end

module ActionView
  module Helpers
    module UrlHelper
      def link_to_with_sentience(name, options = {}, html_options = nil, *parameters_for_method_reference)
        link_to_without_sentience name.upcase, options, html_options, *parameters_for_method_reference
      end

      alias_method_chain :link_to, :sentience
    end
  end
end

