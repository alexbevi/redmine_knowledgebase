module KnowledgebaseSettingsHelper
  def redmine_knowledgebase_settings_value(key)
    Setting['plugin_redmine_knowledgebase'][key]
  end
  
  def redmine_knowledgebase_count_article_summaries
    "#{KbArticle.count_article_summaries} of #{KbArticle.count} have summaries"
  end
end