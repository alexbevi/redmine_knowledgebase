class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :kb_articles do |t|
      t.column :category_id, :int, :null => false
      t.column :title, :string, :null => false
      t.column :summary, :text
      t.column :content, :text
      t.timestamps
    end
  end

  def self.down
    drop_table :kb_articles
  end
end
