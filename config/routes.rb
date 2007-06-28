ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  map.resource :session
  map.login 'login', :controller => "session", :action => "new"
  map.logout 'logout', :controller => "session", :action => "destroy"

  map.resources :shows, :collection => { :current => :get } do |show|
    show.resources :performances, :name_prefix => "show_", :member => { :open => :put }
    show.resources :bookings, :name_prefix => "show_"
    show.resources :roles, :name_prefix => "show_", :collection => { :reorder => :put }
  end
  map.resources :events
  map.resources :bookings
  map.resources :venues
  map.resources :news, :singular => "post"
  
  map.dramasoc 'dramasoc/:action', :controller => "dramasoc", :action => "home"
  map.home 'dramasoc', :controller => "dramasoc", :action => "home"
  map.connect '', :controller => "shows", :action => "current"

  # Install the default route as the lowest priority.
  #map.connect ':controller/:action/:id.:format'
  #map.connect ':controller/:action/:id'
end
