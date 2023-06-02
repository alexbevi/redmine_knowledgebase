module RedmineKnowledgebase
end

if Rails.try(:autoloaders).try(:zeitwerk_enabled?)
  RedmineKnowledgebase::Macros
else
  require 'redmine'
  require 'redmine_knowledgebase/macros'
  require 'redmine_knowledgebase/concerns/knowledgebase_project_extension'
  require 'redmine_knowledgebase/helpers/knowledgebase_link_helper'
  require 'redmine_knowledgebase/helpers/knowledgebase_settings_helper'
end

Project.send :include, RedmineKnowledgebase::Concerns::KnowledgebaseProjectExtension
SettingsHelper.send :include, RedmineKnowledgebase::Helpers::KnowledgebaseSettingsHelper
ApplicationHelper.send :include, RedmineCrm::TagsHelper

Rails.configuration.to_prepare do
  Redmine::Activity.register :kb_articles
  Redmine::Search.available_search_types << 'kb_articles'
end

class RedmineKnowledgebaseHookListener < Redmine::Hook::ViewListener
  render_on :view_layouts_base_html_head, :inline => "<%= stylesheet_link_tag 'knowledgebase', :plugin => :redmine_knowledgebase %>"
end
