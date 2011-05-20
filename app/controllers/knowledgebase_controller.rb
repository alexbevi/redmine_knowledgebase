class KnowledgebaseController < ApplicationController
  unloadable

  #Authorize against global permissions defined in init.rb
  before_filter :authorize_global, :unless => :allow_anonymous_access?
  
  rescue_from ActionView::MissingTemplate, :with => :force_404
  rescue_from ActiveRecord::RecordNotFound, :with => :force_404
  
  def index
    summary_limit = 5
    
    @categories = Category.find(:all)
    @articles_newest   = Article.find(:all, :limit => summary_limit, :order => 'created_at DESC')
    @articles_updated  = Article.find(:all, :limit => summary_limit, :conditions => ['created_at <> updated_at'], :order => 'updated_at DESC')
    
    #FIXME the following method still requires ALL records to be loaded before being filtered.
    
    a = Article.find(:all, :include => :viewings).sort_by(&:view_count)
    @articles_popular  = a.drop(a.count - summary_limit).reverse
    a = Article.find(:all, :include => :ratings).sort_by(&:rated_count)
    @articles_toprated = a.drop(a.count - summary_limit).reverse
  end

#########
protected
#########

  def is_user_logged_in
    if !User.current.logged?
      render_403
    end
  end
  
  def allow_anonymous_access?
    Setting['plugin_redmine_knowledgebase']['knowledgebase_anonymous_access'].to_i == 1
  end

#######
private
#######

  def force_404
    render_404
  end

end

