ActionController::Routing::Routes.draw do |map|
  map.resources :categories, :path_prefix => '/knowledgebase'
  map.resources :articles, :path_prefix => '/knowledgebase'
end