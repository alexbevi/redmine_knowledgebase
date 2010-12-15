class Article < ActiveRecord::Base
  unloadable

  require 'acts_as_viewed'
  require 'acts_as_rated'
  require 'acts_as_taggable'

  acts_as_viewed
  acts_as_rated :no_rater => true
  acts_as_taggable
  acts_as_attachable

  acts_as_searchable :columns => ["kb_articles.title", "kb_articles.content"], :no_project_scope => true, :order_column => "kb_articles.id"

  acts_as_event :title => Proc.new {|o| "#{l(:label_title_articles)} ##{o.id}: #{o.title}" },
                  :description => Proc.new {|o| "#{o.content}"},
                  :datetime => :created_at,
                  :type => 'articles',
                  :url => Proc.new {|o| {:controller => 'articles', :action => 'show', :id => nil, :article_id => o.id} }

  has_many :comments, :as => :commented, :dependent => :delete_all, :order => "created_on"

  validates_presence_of :title
  validates_presence_of :category_id

  belongs_to :category
  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'

  def self.table_name() "kb_articles" end

  # This overrides the instance method in acts_as_attachable
  def attachments_visible?(user=User.current)
    true
  end

  def attachments_deletable?(user=User.current)
    user.logged?
  end

  # XXX this is required by acts_as_attachable. Without this, trying to download
  # a file throws the following:
  # "NoMethodError (undefined method 'project' for #(ActiveRecord::Associations::BelongsToPolymorphicAssociation))"
  def project
    nil
  end

end

