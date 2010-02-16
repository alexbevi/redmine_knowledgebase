class KnowledgebaseController < ApplicationController
  unloadable
  
  before_filter :is_user_logged_in, :only => :edit
  
  def index
    @articles_newest = Article.find(:all)
  end

protected
  
  def is_user_logged_in
    if !User.current.logged?
      render_403
    end
  end
  
end
