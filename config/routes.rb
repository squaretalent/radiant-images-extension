ActionController::Routing::Routes.draw do |map|
  
  map.namespace :admin, :member => { :remove => :get } do |admin|
    admin.resources :images
    admin.resources :attachments, :collection => { :sort => :put }
  end
  
end