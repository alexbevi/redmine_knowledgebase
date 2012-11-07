class KnowledgebaseController < ApplicationController
  unloadable
  
  before_filter :find_project, :authorize
  
  rescue_from ActionView::MissingTemplate, :with => :force_404
  rescue_from ActiveRecord::RecordNotFound, :with => :force_404

  def find_project
    if !params[:project_id].nil?
        @project=Project.find(params[:project_id])
    end
  end
  
  def index
    begin
      summary_limit = Setting['plugin_redmine_knowledgebase']['knowledgebase_summary_limit'].to_i
    rescue
      summary_limit = 5
    end
    
    @categories = @project.categories.find(:all)

    @articles_newest   = @project.articles.find(:all, :limit => summary_limit, :order => 'created_at DESC')
    @articles_updated  = @project.articles.find(:all, :limit => summary_limit, :conditions => ['created_at <> updated_at'], :order => 'updated_at DESC')
    
    a = @project.articles.find(:all, :include => :viewings).sort_by(&:view_count)
    a = a.drop(a.count - summary_limit) if a.count > summary_limit
    @articles_popular  = a.reverse
    a = @project.articles.find(:all, :include => :ratings).sort_by(&:rated_count)
    a = a.drop(a.count - summary_limit) if a.count > summary_limit
    @articles_toprated = a.reverse

    @tags = @project.articles.tag_counts
  end

#########
protected
#########

  def is_user_logged_in
    if !User.current.logged?
      render_403
    end
  end

#######
private
#######

  def force_404
    render_404
  end

end

