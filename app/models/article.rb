class Article < ActiveRecord::Base
  unloadable
  
  require 'acts_as_viewed'
  require 'acts_as_rated'
  
  acts_as_viewed
  acts_as_rated :no_rater => true
  
  acts_as_attachable :after_remove => :attachment_removed
  
  validates_presence_of :title  
  validates_presence_of :category_id
  
  belongs_to :category
  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'
  
  def self.table_name() "kb_articles" end
  
  # This overrides the instance method in acts_as_attachable 
  def attachments_visible?(user=User.current)
    true
  end
  
  # acts_as_attachable requires a project association
  def project
    nil
  end

end
