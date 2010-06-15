ActionController::Routing::Routes.draw do |map|
  
  map.namespace :admin, :member => { :remove => :get } do |admin|
    admin.resources :images, :collection => { :search => :get }
  end

  map.images 'images/:id/:style', :controller => 'images', :action => 'show', :defaults => { :style => Radiant::Config['images.default'] }
  
end