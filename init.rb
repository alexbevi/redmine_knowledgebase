require 'redmine'
require 'redmine_acts_as_taggable_on/initialize'

Rails.configuration.to_prepare do
  Redmine::Activity.register :kb_articles
  Redmine::Search.available_search_types << 'kb_articles'
end

ActionDispatch::Reloader.to_prepare do
  require 'macros'
  require 'concerns/knowledgebase_project_extension'
  Project.send :include, KnowledgebaseProjectExtension
  SettingsHelper.send :include, KnowledgebaseSettingsHelper
end

Redmine::Plugin.register :redmine_knowledgebase do
  name        'Knowledgebase'
  author      'Alex Bevilacqua'
  author_url  "http://www.alexbevi.com"
  description 'A plugin for Redmine that adds knowledgebase functionality'
  url         'https://github.com/alexbevi/redmine_knowledgebase'
  version     '3.0.7'

  requires_redmine :version_or_higher => '2.0.0'
  requires_acts_as_taggable_on

  settings :default => {
    :sort_category_tree => true,
    :show_category_totals => true,
    :summary_limit => 25,
    :disable_article_summaries => false
  }, :partial => 'redmine_knowledgebase/knowledgebase_settings'

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

class RedmineKnowledgebaseHookListener < Redmine::Hook::ViewListener
  render_on :view_layouts_base_html_head, :inline => "<%= stylesheet_link_tag 'knowledgebase', :plugin => :redmine_knowledgebase %>"
end
