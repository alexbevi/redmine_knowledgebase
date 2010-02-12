class CategoriesController < ApplicationController
	unloadable
	
  def index
		@categories = Category.find(:all)   
  end

  def show
    @category = Category.find(params[:id])
  end

  def new
    @category = Category.new
    
    respond_to do |format|
      format.html
    end    
  end
  
  def create
    @category = Category.new(params[:category])
    if @category.save
      flash[:notice] = "Created Category: " + @category.title
      redirect_to({ :controller => 'knowledgebase', :action => 'index' })
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