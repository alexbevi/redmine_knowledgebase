ActionController::Routing::Routes.draw do |map|
  map.resources :categories, :path_prefix => '/knowledgebase', :conditions => { :method => [:get, :post] } 
  map.resources :articles, :path_prefix => '/knowledgebase', :conditions => { :method => [:get, :post] }
end