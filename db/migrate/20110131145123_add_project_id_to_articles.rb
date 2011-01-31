class AddProjectIdToArticles < ActiveRecord::Migration
  def self.up
    add_column :kb_articles, :project_id, :int, :default => 0
  end

  def self.down
    remove_column :kb_articles, :project_id
  end
end

