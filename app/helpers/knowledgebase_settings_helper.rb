module KnowledgebaseSettingsHelper
  def redmine_knowledgebase_settings_value(key)
    defaults = Redmine::Plugin::registered_plugins[:redmine_knowledgebase].settings[:default]

    begin
      value = Setting['plugin_redmine_knowledgebase'][key]
      value = nil if value.blank?
    rescue
      value ||= defaults[key]
    end

    value
  end
  
  def redmine_knowledgebase_count_article_summaries
    "#{KbArticle.count_article_summaries} of #{KbArticle.count} have summaries"
  end
end