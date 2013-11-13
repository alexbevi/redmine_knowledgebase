module KnowledgebaseSettingsHelper
  def settings_value(key)
    defaults = Redmine::Plugin::registered_plugins[:redmine_knowledgebase].settings[:default]

    value = Setting['plugin_redmine_knowledgebase'][key]
    value = nil if value.blank?
    value ||= defaults[key]

    begin
      Integer(value)
    rescue
      value
    end
  end
end