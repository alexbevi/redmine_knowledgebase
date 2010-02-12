class Article < ActiveRecord::Base
  validates_presence_of :title  
  validates_presence_of :category_id
  
  belongs_to :category
  
  def self.table_name() "kb_articles" end
end
