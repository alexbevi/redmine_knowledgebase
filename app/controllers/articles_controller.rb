class ArticlesController < KnowledgebaseController
  unloadable
  
  helper :attachments
  include AttachmentsHelper
  include FaceboxRender

  #Authorize against global permissions defined in init.rb
  before_filter :authorize_global
  
  def new
    @article = KbArticle.new
    @default_category = params[:category_id]
    @article.category_id = params[:category_id]
  end
  
  def rate
    @article = KbArticle.find(params[:article_id])
    @article.rate params[:rating].to_i
    render :partial => "rating", :locals => {:article => @article}
  end
  
  def create    
    @article = KbArticle.new(params[:article])
    @article.category_id = params[:category_id]
    @article.author_id = User.current.id
    if @article.save
      attachments = attach(@article, params[:attachments])
      flash[:notice] = l(:label_article_created, :title => @article.title)
      redirect_to({ :controller => 'categories', :action => 'show', :id => @article.category_id })
    else
      render(:action => 'new')
    end
  end
  
  def show
    @article = KbArticle.find(params[:id] || params[:article_id])
    @article.view request.remote_addr, User.current
    @attachments = @article.attachments.find(:all, :order => "created_on DESC")
    @comments = @article.comments
  end
  
  def edit
    @article = KbArticle.find(params[:id])
  end
  
  def update
    @article = KbArticle.find(params[:id])
    params[:article][:category_id] = params[:category_id]
    if @article.update_attributes(params[:article])
      attachments = attach(@article, params[:attachments])
      flash[:notice] = l(:label_article_updated)
      redirect_to({ :action => 'show', :id => @article.id })
    else
      render({:action => 'edit', :id => @article.id})
    end
  end
  
  def add_comment
    @article = KbArticle.find(params[:id])
    @comment = Comment.new(params[:comment])
    @comment.author = User.current || nil
    if @article.comments << @comment
      flash[:notice] = l(:label_comment_added)
      redirect_to :action => 'show', :id => @article
    else
      show
      render :action => 'show'
    end
  end

  def destroy_comment
    @article = KbArticle.find(params[:id])
    @article.comments.find(params[:comment_id]).destroy
    redirect_to :action => 'show', :id => @article
  end
  
  def destroy
    @article = KbArticle.find(params[:id])
    @article.destroy
    flash[:notice] = l(:label_article_removed)
    redirect_to({ :controller => 'knowledgebase', :action => 'index' })
  end

  def add_attachment
    @article = KbArticle.find(params[:id])
    attachments = attach(@article, params[:attachments])    
    redirect_to({ :action => 'show', :id => @article.id })
  end
  
  def tagged
    @tag = params[:id]
    @list = KbArticle.find_tagged_with(@tag)
  end

  def preview
    @summary = (params[:article] ? params[:article][:summary] : nil)
    @content = (params[:article] ? params[:article][:content] : nil)
    render :layout => false
  end
  
  def comment
    @article_id = params[:article_id]
    render_to_facebox
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
end
