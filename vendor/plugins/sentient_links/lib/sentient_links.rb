module SentientLinks
end

module ActionView
  module Helpers
    module UrlHelper
      def link_to_with_sentience(name, options = {}, html_options = nil, *parameters_for_method_reference)
        url = options.is_a?(String) ? options : self.url_for(options, *parameters_for_method_reference)
        do_fancy_link = false

        begin
          if url.starts_with? '/'
            request = DummyRequest.new
            request.env["REQUEST_METHOD"] = options[:method].to_s.upcase if options[:method]
            request.path = url
            controller = ActionController::Routing::Routes.recognize(request)
            if !controller.nil?
              protected_actions = (controller.included_actions.select { |k, v| is_filtered? k.filter }.first || []).last || []
              do_fancy_link = protected_actions.include? request.path_parameters[:action].to_s
            end
          end
        rescue ActionController::RoutingError
          do_fancy_link = false
        ensure
          if do_fancy_link and !logged_in?
            name, options, html_options = augment_link_options name, options, html_options
          end
        end
        link_to_without_sentience name, options, html_options, *parameters_for_method_reference
      end

      alias_method_chain :link_to, :sentience

      def is_filtered?(filter_name)
        filter_name == :login_required
      end

      def augment_link_options(name, options, html_options)
        html_options[:onclick] ||= "alert('You need to log in for that!'); return false;"
        html_options[:class] = [ html_options[:class], "login-required" ].compact.join ' '
        [ name, options, html_options ]
      end

      class DummyRequest < ActionController::AbstractRequest #:nodoc:
        # Ganked from TestRequest, with the irrelevant bits ripped out
        
        attr_accessor :query_parameters, :request_parameters, :path, :session, :env
        attr_accessor :host

        def initialize(query_parameters = nil, request_parameters = nil)
          @query_parameters   = query_parameters || {}
          @request_parameters = request_parameters || {}
          @session            = nil

          initialize_containers
          initialize_default_values

          super()
        end

        def port=(number)
          @env["SERVER_PORT"] = number.to_i
          @port_as_int = nil
        end

        def action=(action_name)
          @query_parameters.update({ "action" => action_name })
          @parameters = nil
        end

        def request_uri=(uri)
          @request_uri = uri
          @path = uri.split("?").first
        end

        def request_uri
          @request_uri || super()
        end

        def path
          @path || super()
        end

      private
        def initialize_containers
          @env, @cookies = {}, {}
        end

        def initialize_default_values
          @host                    = "test.host"
          @request_uri             = "/"
          @env["SERVER_PORT"]      = 80
          @env['REQUEST_METHOD']   = "GET"
        end
      end
    end
  end
end
