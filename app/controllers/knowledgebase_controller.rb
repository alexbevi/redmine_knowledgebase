class KnowledgebaseController < ApplicationController
  unloadable

  #Authorize against global permissions defined in init.rb
  before_filter :authorize_global

  def index
    @categories = Category.find(:all)
    @articles_newest   = Article.find(:all, :limit => 5, :order => 'created_at DESC')
    @articles_updated  = Article.find(:all, :limit => 5, :conditions => ['created_at <> updated_at'], :order => 'updated_at DESC')
    @articles_popular  = Article.find(:all, :include => :viewings).sort_by(&:view_count).reverse
    @articles_toprated = Article.find(:all, :include => :ratings).sort_by(&:rated_count).reverse
  end

  protected

  def is_user_logged_in
    if !User.current.logged?
      render_403
    end
  end

end

