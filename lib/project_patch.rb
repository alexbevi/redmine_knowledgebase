module KnowledgeBase
  module ProjectPatch
    def self.included(base)
      base.class_eval do
        unloadable
        has_many :categories, :class_name => "KbCategory", :foreign_key => "project_id"
        has_many :articles, :class_name => "KbArticle", :foreign_key => "project_id"
      end
    end
  end
end

Rails.configuration.to_prepare do
  require_dependency 'project'
  Project.send(:include, KnowledgeBase::ProjectPatch)
end
