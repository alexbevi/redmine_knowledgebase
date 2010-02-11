class Category < ActiveRecord::Base
  validates_presence_of :title  
  
  def self.table_name() "kb_categories" end
end
