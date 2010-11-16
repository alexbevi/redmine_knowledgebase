class KnowledgebaseController < ApplicationController
  unloadable
  
  before_filter :is_user_logged_in, :only => :edit
  before_filter :is_user_allowed?
  
  def index
    @categories = Category.find(:all)
    @articles_newest   = Article.find(:all, :limit => 5, :order => 'created_at DESC')
    @articles_updated  = Article.find(:all, :limit => 5, :order => 'updated_at DESC')
    @articles_toprated = Article.find(:all, :limit => 5, :order => 'updated_at DESC')
    @articles_popular  = Article.find(:all, :limit => 5, :order => 'updated_at DESC')
  end

protected
  
  def is_user_logged_in
    if !User.current.logged?
      render_403
    end
  end

  def is_user_allowed?
    render_403 unless User.current.groups.detect {|g| g.lastname == 'ESL Staff'}
  end  
end
