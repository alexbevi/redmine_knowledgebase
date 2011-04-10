require 'redmine'
require 'acts_as_viewed'
require 'acts_as_rated'
require 'acts_as_taggable'

Redmine::Plugin.register :redmine_knowledgebase do
  name        'Knowledgebase'
  author      'Alex Bevilacqua'
  description 'A plugin for Redmine that adds knowledgebase functionality'
  url         'http://projects.alexbevi.com/projects/redmine-kb'
  author_url  'http://blog.alexbevi.com'
  version     '0.2.5'

  requires_redmine :version_or_higher => '0.8.0'

  #Global permissions
  project_module :knowledgebase do
    permission :view_articles, {
      :knowledgebase => :index,
      :articles => [:show],:categories => [:index,:show]
    }
    permission :comment_and_rate_articles, {
      :knowledgebase => :index,
      :articles => [:show,:rate,:add_comment]
    }
    permission :create_articles, {
      :knowledgebase => :index,
      :articles => [:show,:new,:create,:add_attachment,:tagged,:preview]
    }
    permission :edit_articles, {
      :knowledgebase => :index,
      :articles => [:show,:edit,:update,:add_attachment,:tagged,:preview]
    }
    permission :manage_articles, {
      :knowledgebase => :index,
      :articles => [:show,:new,:create,:edit,:update,:destroy,:add_attachment,:preview,:destroy_comment,:tagged]
    }
    permission :manage_articles_comments, {
      :knowledgebase => :index,
      :articles => [:show,:add_comment,:destroy_comment]
    }
    permission :create_article_categories, {
      :knowledgebase => :index,
      :categories => [:index,:show,:new,:create]
    }
    permission :manage_article_categories, {
      :knowledgebase => :index,
      :categories => [:index,:show,:new,:create,:edit,:update,:delete]
    }
  end
  
  menu :top_menu, :knowledgebase, { :controller => 'knowledgebase', :action => 'index'}, :caption => 'Knowledgebase',:if =>  Proc.new {
    User.current.allowed_to?({:controller => 'knowledgebase', :action => 'index'},nil, :global => true)
  }

  Redmine::Search.available_search_types << 'articles'
end