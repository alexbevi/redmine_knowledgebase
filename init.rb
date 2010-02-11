require 'redmine'

Redmine::Plugin.register :redmine_knowledgebase do
  name 'Redmine Knowledgebase plugin'
  author 'Alex Bevilacqua'
  description 'A plugin for Redmine that adds knowledgebase functionality'
  url 'http://github.com/alexbevi'
  author_url 'http://blog.alexbevi.com'
  version '0.0.1'
  
  requires_redmine :version_or_higher => '0.8.0'

  menu :top_menu, :knowledgebase, { :controller => 'knowledgebase', :action => 'index'}, :caption => 'Knowledgebase'
end
