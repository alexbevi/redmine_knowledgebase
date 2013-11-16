module KnowledgebaseSettingsHelper
  def settings_value(key)
    Setting['plugin_redmine_knowledgebase'][key]
  end
  
  def count_article_summaries
    without = KbArticle.count(:conditions => ["summary is not null and summary != ''"])
    "#{without} of #{KbArticle.count} have summaries"
  end
end