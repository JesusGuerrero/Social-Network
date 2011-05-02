ActionController::Routing::Routes.draw do |map|
  map.resources :chats

  map.resources :pages, :only => [ :about ]
  map.resources :networks
  map.resources :memberships
  map.resources :microposts
	map.resources :videos
	map.resources :photos
	map.resources :photo_comments
	map.resources :video_comments
	map.resources :members, :only => [ :index, :networks, :users ]
	map.resources :message_systems, :only => [ :index, :new, :create ]
	map.messages 'messages/:action', :controller => 'message_systems'
	map.people 'people/:action', :controller => 'members'
	
	map.about '/about', :controller => 'pages', :action => 'about'
	map.terms '/terms', :controller => 'pages', :action => 'terms'
	map.privacy '/privacy', :controller => 'pages', :action => 'privacy'
	map.contact '/contact', :controller => 'pages', :action => 'contact'
	map.feedback '/feedback', :controller => 'pages', :action => 'feedback'
 	map.name '/network/:name', :controller => 'networks', :action => 'show'	
  map.resource :user_session
	map.root :controller => "users", :action => "show"
  map.resources :users
  map.signup  "signup/",  :controller => 'users', :action => 'new'
	map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate'
  map.signin "signin/", :controller => "user_sessions", :action => "new"
  map.signout "signout/", :controller => "user_sessions", :action => "destroy"
  map.resources :tutorials
  map.tutorial_pages "tutorials/:category/:permalink", :controller => "tutorials", :action => "show"
  map.website_start "tutorials/website-setup/starting-point-for-success", :controller => "tutorials", :action => "show"
  map.keyword_start "tutorials/keyword-research/keyword-research-overview", :controller => "tutorials", :action => "show"
  map.content_start "tutorials/creating-content/content-creation-overview", :controller => "tutorials", :action => "show"
  map.linking_start "tutorials/getting-backlinks/backlinking-overview", :controller => "tutorials", :action => "show"
  map.resources :websites, :only => [:new, :edit, :create, :update, :destroy]
  map.resources :keywords, :only => [:new, :edit, :create, :update, :destroy]
  map.resources :projects
  map.resources :workers
  map.resources :basecamp, :member => { :project1 => :get, :project2 => :get }

	map.resources :password_resets, :only => [ :new, :create, :edit, :update ]
	map.resources :shopping_car, :only => [ :listener ]
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
