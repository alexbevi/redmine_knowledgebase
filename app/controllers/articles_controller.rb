class ArticlesController < KnowledgebaseController
  unloadable    
  
  def new
    @article = Article.new
    @default_category = params[:category_id]
  end
  
  def create    
    @article = Article.new(params[:article])
    @article.author_id = User.current.id
    if @article.save
      flash[:notice] = "Created Article " + @article.title
      redirect_to({ :controller => 'knowledgebase', :action => 'index' })
    else
      render(:action => 'new')
    end
  end
  
  def show
    @article = Article.find(params[:id])
    @article.view request.remote_addr, User.current
  end
  
  def edit
    @article = Article.find(params[:id])
  end
  
  def update
    @article = Article.find(params[:id])
    
    if @article.update_attributes(params[:article])
      flash[:notice] = "Article Updated"
      redirect_to({ :controller => 'knowledgebase', :action => 'index' })
    else
      render({:action => 'edit', :id => @article.id})
    end    
  end
  
  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    flash[:notice] = "Article Removed"
    redirect_to({ :controller => 'knowledgebase', :action => 'index' })    
  end

end
