class Article < ActiveRecord::Base
  unloadable
  
  require 'acts_as_viewed'
  require 'acts_as_rated'
  
  acts_as_viewed
  acts_as_rated :no_rater => true
  
  validates_presence_of :title  
  validates_presence_of :category_id
  
  belongs_to :category
  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'
  
  def self.table_name() "kb_articles" end
end
