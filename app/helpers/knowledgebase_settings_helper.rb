module KnowledgebaseSettingsHelper
  def settings_value(key)
    defaults = Redmine::Plugin::registered_plugins[:redmine_knowledgebase].settings[:default]

    value = Setting['plugin_redmine_knowledgebase'][key]
    value = nil if value.blank?
    value ||= defaults[key]

    value
  end
  
  def count_article_summaries
    without = KbArticle.count(:conditions => ["summary is not null and summary != ''"])
    "#{without} of #{KbArticle.count} have summaries"
  end
end