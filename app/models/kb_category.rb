class KbCategory < ActiveRecord::Base
  unloadable
  
  self.table_name = "kb_categories"
  
  validates_presence_of :title
  
  belongs_to :project
  
  has_many :articles, :class_name => "KbArticle", :foreign_key => "category_id"
  
  acts_as_nested_set :order => 'title'

  acts_as_watchable
  
  # check the category whitelist (if it's defined) to see if the
  # provided user is explicetly allowed to access content
  def blacklisted?(user)
    return false if self.user_whitelist.blank?

    whitelisted = self.user_whitelist.split(",").include?(user.id.to_s)
    !whitelisted
  end
end
