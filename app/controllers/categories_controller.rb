class CategoriesController < ApplicationController
	unloadable
	
  def index
		@categories = Category.find(:all)   
  end

  def show
    @category = Category.find(params[:id])
    @articles = @category.articles.find(:all)
  end

  def new
    @category = Category.new        
  end
  
  def create
    @category = Category.new(params[:category])
    if @category.save
      flash[:notice] = "Created Category: " + @category.title
      redirect_to({ :action => 'show', :id => @category.id })
    else
      render(:action => 'new')
    end
  end
  
  def edit
    @category = Category.find(params[:id])   
  end
  
  def update
    @category = Category.find(params[:id])
    
    if @category.update_attributes(params[:category])
      flash[:notice] = "Category Updated"
      redirect_to({ :controller => 'knowledgebase', :action => 'index' })
    else
      render(:action => 'edit')
    end   
  end
  
end
