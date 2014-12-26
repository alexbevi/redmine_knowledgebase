class AddArticleVersionsComments < ActiveRecord::Migration
  def self.up
    add_column :kb_article_versions, :version_comments, :string, limit: 255, default: "" unless column_exists?(:kb_article_versions, :version_comments)
  end
end