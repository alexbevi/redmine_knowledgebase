require 'redmine'
require 'acts_as_viewed'
require 'acts_as_rated'
require 'project_patch'

#Register KB macro
require 'macros'

Redmine::Plugin.register :redmine_knowledgebase do
  name        'Knowledgebase'
  author      'Alex Bevilacqua'
  description 'A plugin for Redmine that adds knowledgebase functionality'
  url         'https://github.com/alexbevi/redmine_knowledgebase'
  version     '2.2.0'

  requires_redmine :version_or_higher => '2.0.0'
  
  settings :default => {
    'knowledgebase_sort_category_tree' => "1",
    'knowledgebase_show_category_totals' => "1",
    'knowledgebase_summary_limit' => "5"
  }, :partial => 'settings/knowledgebase_settings'

  #Global permissions
  project_module :knowledgebase do
    permission :view_articles, {
      :knowledgebase => :index,
      :articles      => [:show, :tagged],
      :categories    => [:index, :show]
    }
    permission :comment_and_rate_articles, {
      :knowledgebase => :index,
      :articles      => [:show, :tagged, :rate, :comment, :add_comment],
      :categories    => [:index, :show]
    }
    permission :create_articles, {
      :knowledgebase => :index,
      :articles      => [:show, :tagged, :new, :create, :add_attachment, :preview],
      :categories    => [:index, :show]
    }
    permission :edit_articles, {
      :knowledgebase => :index,
      :articles      => [:show, :tagged, :edit, :update, :add_attachment, :preview],
      :categories    => [:index, :show]
    }
    permission :manage_articles, {
      :knowledgebase => :index,
      :articles      => [:show, :new, :create, :edit, :update, :destroy, :add_attachment, 
                         :preview, :comment, :add_comment, :destroy_comment, :tagged],
      :categories    => [:index, :show]
    }
    permission :manage_articles_comments, {
      :knowledgebase => :index,
      :articles      => [:show, :comment, :add_comment, :destroy_comment],
      :categories    => [:index, :show]
    }
    permission :create_article_categories, {
      :knowledgebase => :index,
      :categories    => [:index, :show, :new, :create]
    }
    permission :manage_article_categories, {
      :knowledgebase => :index,
      :categories    => [:index, :show, :new, :create, :edit, :update, :destroy]
    }
    permission :watch_articles, {
      :watchers		=> [:new, :destroy]
    }
    permission :watch_categories, {
      :watchers => [:new, :destroy]
    }
  end
  
  menu :project_menu, :knowledgebase, { :controller => 'knowledgebase', :action => 'index' }, :caption => :knowledgebase_title, :after => :activity, :param => :project_id
  
  Redmine::Activity.map do |activity|
      activity.register :articles, :class_name => 'KbArticle'
  end
  
  Redmine::Search.available_search_types << 'kb_articles'
end
