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
  version     '3.0.0-devel1'

  requires_redmine :version_or_higher => '2.0.0'
  
  settings :default => {
    'knowledgebase_sort_category_tree' => "1",
    'knowledgebase_show_category_totals' => "1",
    'knowledgebase_summary_limit' => "5"
  }, :partial => 'settings/knowledgebase_settings'

  #Global permissions
  project_module :knowledgebase do
    permission :view_kb_articles, {
      :articles      => [:index, :show, :tagged],
      :categories    => [:index, :show]
    }
    permission :comment_and_rate_articles, {
      :articles      => [:index, :show, :tagged, :rate, :comment, :add_comment],
      :categories    => [:index, :show]
    }
    permission :create_articles, {
      :articles      => [:index, :show, :tagged, :new, :create, :add_attachment, :preview],
      :categories    => [:index, :show]
    }
    permission :edit_articles, {
      :articles      => [:index, :show, :tagged, :edit, :update, :add_attachment, :preview],
      :categories    => [:index, :show]
    }
    permission :manage_articles, {
      :articles      => [:index, :show, :new, :create, :edit, :update, :destroy, :add_attachment, 
                         :preview, :comment, :add_comment, :destroy_comment, :tagged],
      :categories    => [:index, :show]
    }
    permission :manage_articles_comments, {
      :articles      => [:index, :show, :comment, :add_comment, :destroy_comment],
      :categories    => [:index, :show]
    }
    permission :create_article_categories, {
      :articles      => :index,
      :categories    => [:index, :show, :new, :create]
    }
    permission :manage_article_categories, {
      :articles      => :index,
      :categories    => [:index, :show, :new, :create, :edit, :update, :destroy]
    }
    permission :watch_articles, {
      :watchers		=> [:new, :destroy]
    }
    permission :watch_categories, {
      :watchers => [:new, :destroy]
    }
    permission :view_recent_articles, {
      :articles => :index
    }
    permission :view_most_popular_articles, {
      :articles => :index
    }
    permission :view_top_rated_articles, {
      :articles => :index
    }
    permission :view_article_history, {
      :articles => [:diff, :version]
    }
    permission :manage_article_history, {
      :articles => [:diff, :version, :revert]
    }
  end
  
  menu :project_menu, :articles, { :controller => 'articles', :action => 'index' }, :caption => :knowledgebase_title, :after => :activity, :param => :project_id
  
end

Redmine::Activity.map do |activity|
    activity.register :kb_articles
end
  
Redmine::Search.available_search_types << 'kb_articles'

class RedmineKnowledgebaseHookListener < Redmine::Hook::ViewListener
    render_on :view_layouts_base_html_head, :inline => "<%= stylesheet_link_tag 'knowledgebase', :plugin => :redmine_knowledgebase %>"
end 