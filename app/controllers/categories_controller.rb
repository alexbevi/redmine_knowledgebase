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
  
end
