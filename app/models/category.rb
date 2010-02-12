class Category < ActiveRecord::Base
  #acts_as_nested_set :order => 'title'
  
  validates_presence_of :title  
  
  has_many :articles
  
  def self.table_name() "kb_categories" end
end
