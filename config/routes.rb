ActionController::Routing::Routes.draw do |map|
  map.connect "/knowledgebase", :controller => "knowledgebase", :action => "index", :conditions => { :method => :get }
  map.resources :categories, :path_prefix => '/knowledgebase', :conditions => { :method => [:get, :post] } 
  map.resources :articles, :path_prefix => '/knowledgebase', :conditions => { :method => [:get, :post] }
  
  map.with_options :controller => 'articles' do |article_routes|
    article_routes.with_options :conditions => {:method => :get} do |actions|
      # used when searching (see https://github.com/alexbevi/redmine_knowledgebase/issues/78)
      actions.connect '/knowledgebase/articles/:article_id', :action => 'show'
      actions.connect '/knowledgebase/articles/:id/rate', :action => 'rate'
      actions.connect '/knowledgebase/articles/tagged/:id', :action => 'tagged'
    end
    article_routes.with_options :conditions => {:method => :post} do |actions|
      actions.connect '/knowledgebase/articles/preview', :action => 'preview'
      actions.connect '/knowledgebase/articles/:id', :action => 'update'
      actions.connect '/knowledgebase/articles/:id/comment', :action => 'comment'
      actions.connect '/knowledgebase/articles/:id/add_comment', :action => 'add_comment'
      actions.connect '/knowledgebase/articles/:id/destroy_comment', :action => 'destroy_comment'
    end
  end
end
