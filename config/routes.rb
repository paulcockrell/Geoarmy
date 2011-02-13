ActionController::Routing::Routes.draw do |map|
  map.resources :users
  map.connect 'login/list_users', :controller => 'login', :action => 'list_users'
  map.connect 'login/login', :controller => 'login', :action => 'login'
  map.connect 'login/logout', :controller => 'login', :action => 'logout'
  map.connect 'user/forgotten_password', :controller => 'users', :action => 'forgotten_password'
  map.connect 'user/forgotten_username', :controller => 'users', :action => 'forgotten_username'
  map.connect 'user/reset_password/:id', :controller => 'users', :action => 'reset_password', :object => :id
  map.connect 'favorites/add_favorite', :controller => 'favorites', :action => 'add_favorite'
  map.connect 'connections/add_connection', :controller => 'connections', :action => 'add_connection'
  map.connect 'connections/delete_connection', :controller => 'connections', :action => 'delete_connection'
  map.connect 'profile/connections', :controller => 'connections', :action => 'manage' 
  map.resources :login
  map.resources :faq
  map.resources :favorites
  map.connect 'profile', :controller => 'users', :action => 'show'
  map.connect 'profile/edit', :controller => 'users', :action => 'edit'
  map.connect 'profile/show/:id', :controller => 'users', :action => 'show', :object => :id
  map.connect 'register', :controller => 'users', :action => 'create'
  map.connect 'geocaches/manage_geocaches', :controller => 'geocaches', :action => 'manage_geocaches' 
  map.connect 'geocaches/get_geocaches', :controller => 'geocaches', :action => 'get_geocaches' 
  map.connect 'geocaches/my_uploaded_geocaches', :controller => 'geocaches', :action => 'my_uploaded_geocaches' 
  map.connect 'geocaches/my_favorite_geocaches', :controller => 'geocaches', :action => 'my_favorite_geocaches' 
  map.connect 'geocaches/my_found_geocaches', :controller => 'geocaches', :action => 'my_found_geocaches' 
  map.connect 'news_feed', :controller => 'action_log', :action => 'index' 
  map.connect 'geocaches/save_rating', :controller => 'geocaches', :action => 'save_rating'
  map.resources :geocaches
  map.root :controller => "home" 
  
  map.connect ':controller/:action/'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

end
