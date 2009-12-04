ActionController::Routing::Routes.draw do |map|
  map.resources :recipes

  map.resources :users

  map.resources :instances

  map.resources :roles

  map.reconcile_all 'farms/reconcile_all', :controller => 'farms', :action => 'reconcile_all'
  
  map.start_by_role 'farms/start_by_role', :controller => 'farms', :action => 'start_by_role'

  map.start_id 'farms/start/:id', :controller => 'farms', :action => 'start'

  map.reconcile_farm 'farms/reconcile/:id', :controller => 'farms', :action => 'reconcile'

  map.resources :farms, :member => {:reconcile => :post, :start => :post}, :collection => {:reconcile_all => :post} 
  # reconcile_farm_path(@farm)
  # ROOT_URL_PATH/farms/:id/reconcile :method => :post
  # start_farm_path(@farm)
  # ROOT_URL_PATH/farms/:id/start :method => :post
  
  # reconcile_all_farms_path()
  # ROOT_URL_PATH/farms/reconcile_all :method => :post 
  map.resources :recipes

  map.terminate_instance 'instances/:id/terminate', :controller => 'instances', :action => 'terminate'
  
  map.instance_state 'instance/set_state/:id', :controller => 'instances', :action => 'state'
  
  map.instance_status 'instance/set_status', :controller => 'instances', :action => 'set_status'

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
  map.root :controller => "instances"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
