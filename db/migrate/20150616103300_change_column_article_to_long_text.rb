class ChangeColumnArticleToLongText < ActiveRecord::Migration
  def self.up
    change_column :kb_articles, :content, :text, :limit => 16.megabytes + 3
  end

end
