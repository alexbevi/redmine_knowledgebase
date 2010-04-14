class ArticlesController < KnowledgebaseController
  unloadable
  
  helper :attachments
  include AttachmentsHelper

  def new
    @article = Article.new
    @default_category = params[:category_id]
  end
  
  
  def rate
    @article = Article.find(params[:article_id])
    @article.rate params[:rating].to_i
    render :partial => "rating", :locals => {:article => @article}
  end
  
  def create    
    @article = Article.new(params[:article])
    @article.category_id = params[:category_id]
    @article.author_id = User.current.id
    if @article.save
      attachments = Attachment.attach_files(@article, params[:attachments])
      render_attachment_warning_if_needed(@article)
      flash[:notice] = "Created Article " + @article.title
      redirect_to({ :controller => 'knowledgebase', :action => 'index' })
    else
      render(:action => 'new')
    end
  end
  
  def show
    @article = Article.find(params[:id])
    @article.view request.remote_addr, User.current
    @attachments = @article.attachments.find(:all, :order => "created_on DESC")
    @comments = @article.comments
  end
  
  def edit
    @article = Article.find(params[:id])
  end
  
  def update
    @article = Article.find(params[:id])
    params[:article][:category_id] = params[:category_id]
    if @article.update_attributes(params[:article])
      attachments = Attachment.attach_files(@article, params[:attachments])
      render_attachment_warning_if_needed(@article)
      flash[:notice] = "Article Updated"
      redirect_to({ :action => 'show', :id => @article.id })
    else
      render({:action => 'edit', :id => @article.id})
    end
  end
  
  def add_comment
    @article = Article.find(params[:id])
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
    @article = Article.find(params[:id])
    @article.comments.find(params[:comment_id]).destroy
    redirect_to :action => 'show', :id => @article
  end
  
  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    flash[:notice] = "Article Removed"
    redirect_to({ :controller => 'knowledgebase', :action => 'index' })
  end

  def add_attachment
    @article = Article.find(params[:id])
    attachments = Attachment.attach_files(@article, params[:attachments])
    render_attachment_warning_if_needed(@article)
    redirect_to({ :action => 'show', :id => @article.id })
  end

end
