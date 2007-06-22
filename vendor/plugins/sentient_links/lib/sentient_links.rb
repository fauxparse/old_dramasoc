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
              protected_actions = (controller.included_actions.select { |k, v| k.filter == :login_required }.first || []).last || []
              do_fancy_link = protected_actions.include? request.path_parameters[:action].to_s
            end
          end
        rescue ActionController::RoutingError
          do_fancy_link = false
        ensure
          if do_fancy_link and !logged_in?
            html_options[:onclick] ||= "alert('You need to log in for that!'); return false;"
            html_options[:class] = [ html_options[:class], "login-required" ].compact.join ' '
            name, options, html_options = augment_link_options name, options, html_options
          end
        end
        link_to_without_sentience name, options, html_options, *parameters_for_method_reference
      end

      alias_method_chain :link_to, :sentience

      def augment_link_options(name, options, html_options)
        html_options[:onclick] ||= "alert('You need to log in for that!'); return false;"
        html_options[:class] = [ html_options[:class], "login-required" ].compact.join ' '
        [ name, options, html_options ]
      end

      class DummyRequest < ActionController::AbstractRequest #:nodoc:
        attr_accessor :cookies, :session_options
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

        def reset_session
          @session = nil
        end

        def raw_post
          if raw_post = env['RAW_POST_DATA']
            raw_post
          else
            params = self.request_parameters.dup
            %w(controller action only_path).each do |k|
              params.delete(k)
              params.delete(k.to_sym)
            end

            params.map { |k,v| [ CGI.escape(k.to_s), CGI.escape(v.to_s) ].join('=') }.sort.join('&')
          end
        end

        def port=(number)
          @env["SERVER_PORT"] = number.to_i
          @port_as_int = nil
        end

        def action=(action_name)
          @query_parameters.update({ "action" => action_name })
          @parameters = nil
        end

        # Used to check AbstractRequest's request_uri functionality.
        # Disables the use of @path and @request_uri so superclass can handle those.
        def set_REQUEST_URI(value)
          @env["REQUEST_URI"] = value
          @request_uri = nil
          @path = nil
        end

        def request_uri=(uri)
          @request_uri = uri
          @path = uri.split("?").first
        end

        def accept=(mime_types)
          @env["HTTP_ACCEPT"] = Array(mime_types).collect { |mime_types| mime_types.to_s }.join(",")
        end

        def remote_addr=(addr)
          @env['REMOTE_ADDR'] = addr
        end

        def remote_addr
          @env['REMOTE_ADDR']
        end

        def request_uri
          @request_uri || super()
        end

        def path
          @path || super()
        end

        def assign_parameters(controller_path, action, parameters)
          parameters = parameters.symbolize_keys.merge(:controller => controller_path, :action => action)
          extra_keys = ActionController::Routing::Routes.extra_keys(parameters)
          non_path_parameters = get? ? query_parameters : request_parameters
          parameters.each do |key, value|
            if value.is_a? Fixnum
              value = value.to_s
            elsif value.is_a? Array
              value = ActionController::Routing::PathSegment::Result.new(value)
            end

            if extra_keys.include?(key.to_sym)
              non_path_parameters[key] = value
            else
              path_parameters[key.to_s] = value
            end
          end
          @parameters = nil # reset TestRequest#parameters to use the new path_parameters
        end                        

        def recycle!
          self.request_parameters = {}
          self.query_parameters   = {}
          self.path_parameters    = {}
          @request_method, @accepts, @content_type = nil, nil, nil
        end    

        private
        def initialize_containers
          @env, @cookies = {}, {}
        end

        def initialize_default_values
          @host                    = "test.host"
          @request_uri             = "/"
          self.remote_addr         = "0.0.0.0"        
          @env["SERVER_PORT"]      = 80
          @env['REQUEST_METHOD']   = "GET"
        end
      end
    end
  end
end
