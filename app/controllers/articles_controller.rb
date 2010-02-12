class ArticlesController < ApplicationController
  unloadable    
  
  def new
    @article = Article.new
    
    respond_to do |format|
      format.html
    end    
  end
  
  def create
    @article = Article.new(params[:article])
    if @article.save
      flash[:notice] = "Created Article " + @article.title
      redirect_to({ :controller => 'knowledgebase', :action => 'index' })
    else
      render(:action => 'new')
    end
  end
  
  def show
    @article = Article.find(params[:id])
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
      render(:action => 'edit')
    end    
  end

end
