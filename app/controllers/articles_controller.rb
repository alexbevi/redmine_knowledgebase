class ArticlesController < ApplicationController
  unloadable

  helper :attachments
  include AttachmentsHelper
  helper :knowledgebase
  include KnowledgebaseHelper
  helper :watchers
  include WatchersHelper

  before_filter :find_project_by_project_id, :authorize
  before_filter :get_article, :except => [:index, :new, :create, :preview, :comment, :tagged, :rate]

  rescue_from ActionView::MissingTemplate, :with => :force_404
  rescue_from ActiveRecord::RecordNotFound, :with => :force_404

  def index
    summary_limit = redmine_knowledgebase_settings_value(:summary_limit).to_i

    @total_categories = @project.categories.count
    @total_articles = @project.articles.count
    @total_articles_by_me = @project.articles.where(:author_id => User.current.id).count

    @categories = @project.categories.where(:parent_id => nil)

    @articles_newest = @project.articles.order("created_at DESC").first(summary_limit)
    @articles_latest = @project.articles.order("updated_at DESC").first(summary_limit)
    @articles_popular = @project.articles.includes(:viewings).limit(summary_limit).sort_by(&:view_count).reverse
    @articles_toprated = @project.articles.includes(:ratings).limit(summary_limit).sort_by(&:rated_count).reverse

    @tags = @project.articles.tag_counts
  end

  def new
    @article = KbArticle.new
    @categories = @project.categories.find(:all)
    @default_category = params[:category_id]
    @article.category_id = params[:category_id]
    @article.version = params[:version]
  end
  
  def rate
    @article = KbArticle.find(params[:id])
    rating = params[:rating].to_i
    @article.rate rating if rating > 0

    respond_to do |f|
      f.js
    end
  end
  
  def create
    @article = KbArticle.new(params[:article])
    @article.category_id = params[:category_id]
    @article.author_id = User.current.id
    @article.project_id = KbCategory.find(params[:category_id]).project_id
    @categories = @project.categories.find(:all)
    # don't keep previous comment
    @article.version_comments = params[:article][:version_comments]
    if @article.save
      attachments = attach(@article, params[:attachments])
      flash[:notice] = l(:label_article_created, :title => @article.title)
      redirect_to({ :action => 'show', :id => @article.id, :project_id => @project })
      KbMailer.article_create(@article).deliver
    else
      render(:action => 'new')
    end
  end
  
  def show
    @article.view request.remote_ip, User.current
    @attachments = @article.attachments.find(:all).sort_by(&:created_on)
    @comments = @article.comments
    @versions = @article.versions.select("id, author_id, version_comments, updated_at, version").order('version DESC')

    respond_to do |format|
      format.html { render :template => 'articles/show', :layout => !request.xhr? }
      format.atom { render_feed(@article, :title => "#{l(:label_article)}: #{@article.title}") }
	  format.pdf  { send_data(article_to_pdf(@article, @project), :type => 'application/pdf', :filename => 'export.pdf') }
    end
  end
  
  def edit
    @categories=@project.categories.find(:all)
    # don't keep previous comment
    @article.version_comments = nil
    @article.version = params[:version]
  end
  
  def update
    @article.updater_id = User.current.id
    params[:article][:category_id] = params[:category_id]
    @categories = @project.categories.find(:all)
    # don't keep previous comment
    @article.version_comments = nil
    @article.version_comments = params[:article][:version_comments]
    if @article.update_attributes(params[:article])
      attachments = attach(@article, params[:attachments])
      flash[:notice] = l(:label_article_updated)
      redirect_to({ :action => 'show', :id => @article.id, :project_id => @project })
      KbMailer.article_update(@article).deliver
    else
      render({:action => 'edit', :id => @article.id})
    end
  end
  
  def add_comment
    @article.without_locking do
      @comment = Comment.new(params[:comment])
      @comment.author = User.current || nil
      if @article.comments << @comment
        flash[:notice] = l(:label_comment_added)
        redirect_to :action => 'show', :id => @article, :project_id => @project
        KbMailer.article_comment(@article, @comment).deliver
      else
        show
        render :action => 'show'
      end
    end
  end

  def destroy_comment
    @article.without_locking do
      @article.comments.find(params[:comment_id]).destroy
      redirect_to :action => 'show', :id => @article, :project_id => @project
    end
  end
  
  def destroy
    KbMailer.article_destroy(@article).deliver
    @article.destroy
    flash[:notice] = l(:label_article_removed)
    redirect_to({ :controller => 'articles', :action => 'index', :project_id => @project})
  end

  def add_attachment
    attachments = attach(@article, params[:attachments])    
    redirect_to({ :action => 'show', :id => @article.id, :project_id => @project })
  end
  
  def tagged
    @tag = params[:id]
    @list = if params[:sort] && params[:direction]
      @project.articles.order("#{params[:sort]} #{params[:direction]}").tagged_with(@tag)	
    else
      @project.articles.tagged_with(@tag)	
    end
  end

  def preview
    @summary = (params[:article] ? params[:article][:summary] : nil)
    @content = (params[:article] ? params[:article][:content] : nil)
    render :layout => false
  end
  
  def comment
    @article_id = params[:article_id]

    respond_to do |f|
      f.js
    end
  end

  def version
    @articleversion = @article.content_for_version(params[:version])
  end
  
  def diff
    @diff = @article.diff(params[:version], params[:version_from])
    render_404 unless @diff
    @articleversion = @article.content_for_version(params[:version])
  end

  def revert
    @article.revert_to! params[:version]
    @article.clear_newer_versions
    redirect_to :action => 'show', :id => @article, :project_id => @project
  end  
#######
private
#######

  # Abstract attachment method to resolve how files should be attached to a model.
  # In newer versions of Redmine, the attach_files functionality was moved
  # from the application controller to the attachment model.
  def attach(target, attachments)
    if Attachment.respond_to?(:attach_files)
      Attachment.attach_files(target, attachments)
      render_attachment_warning_if_needed(target)
    else
      attach_files(target, attachments)
    end
  end

  def get_article
    @article = @project.articles.find(params[:id])
  end

  def force_404
    render_404
  end
  
end
