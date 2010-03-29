class AddCommentsCountToArticles < ActiveRecord::Migration
  def self.up
    add_column :kb_articles, :comments_count, :int
  end

  def self.down
    remove_column :kb_articles, :comments_count
  end
end
