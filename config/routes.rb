ActionController::Routing::Routes.draw do |map|
  map.connect "/knowledgebase", :controller => "knowledgebase", :action => "index", :conditions => { :method => [:get] }
  map.resources :categories, :path_prefix => '/knowledgebase', :conditions => { :method => [:get, :post] } 
  map.resources :articles, :path_prefix => '/knowledgebase', :conditions => { :method => [:get, :post] }
end