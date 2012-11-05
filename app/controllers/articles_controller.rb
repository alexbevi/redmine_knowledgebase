class ArticlesController < KnowledgebaseController
  unloadable
  
  helper :attachments
  include AttachmentsHelper

  before_filter :find_project, :authorize
  before_filter :get_article, :only => [:add_attachment, :show, :edit, :update, :add_comment, :destroy, :destroy_comment]

  def find_project
    if !params[:project_id].nil?
        @project=Project.find(params[:project_id])
    elsif !params[:category_id].nil?
        @project=KbCategory.find(params[:category_id]).project
    elsif !params[:id].nil?
        @project=KbArticle.find(params[:id]).category.project
    elsif !params[:article_id].nil?
        @project=KbArticle.find(params[:article_id]).category.project
    end
  end
  
  def new
    @article = KbArticle.new
	@categories=@project.categories.find(:all)
    @default_category = params[:category_id]
    @article.category_id = params[:category_id]
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
	@article.project_id=KbCategory.find(params[:category_id]).project_id
    if @article.save
      attachments = attach(@article, params[:attachments])
      flash[:notice] = l(:label_article_created, :title => @article.title)
      redirect_to({ :controller => 'categories', :action => 'show', :id=>KbCategory.find(params[:category_id]), :project_id => @project})
	  KbMailer.article_create(@article).deliver
    else
      render(:action => 'new')
    end
  end
  
  def show
    @article.view request.remote_addr, User.current
    @attachments = @article.attachments.find(:all, :order => "created_on DESC")
    @comments = @article.comments
  end
  
  def edit
    @categories=@project.categories.find(:all)
  end
  
  def update
    @article.updater_id = User.current.id
	params[:article][:category_id] = params[:category_id]
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

  def destroy_comment
    @article.comments.find(params[:comment_id]).destroy
    redirect_to :action => 'show', :id => @article, :project_id => @project
  end
  
  def destroy
    KbMailer.article_destroy(@article).deliver
    @article.destroy
    flash[:notice] = l(:label_article_removed)
    redirect_to({ :controller => 'knowledgebase', :action => 'index', :project_id => @project})
  end

  def add_attachment
    attachments = attach(@article, params[:attachments])    
    redirect_to({ :action => 'show', :id => @article.id, :project_id => @project })
  end
  
  def tagged
    @tag = params[:id]
    @list = @project.articles.tagged_with(@tag)	
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
    @article = KbArticle.where(:id => params[:id])
    @article = @article.first if @article.is_a?(ActiveRecord::Relation)
  end
end
