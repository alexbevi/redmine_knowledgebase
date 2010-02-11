class CategoriesController < ApplicationController
	unloadable
	
  def index
		@categories = Category.find(:all)   
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
    end
  end
  
end
