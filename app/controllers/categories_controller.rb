class CategoriesController < KnowledgebaseController
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
      # Test if the new category is a root category, and if more categories exist.
      # We check for a value > 1 because if this is the first entry, the category
      # count would be 1 (since the create operation already succeeded)
      if !params[:root_category] and Category.find(:all).length > 1
        @category.move_to_child_of(Category.find(params[:parent_id]))  
      end
       
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
    if !params[:root_category]
        @category.move_to_child_of(Category.find(params[:parent_id]))
      end
    if @category.update_attributes(params[:category])
      flash[:notice] = "Category Updated"
      redirect_to({ :action => 'show', :id => @category.id })
    else
      render(:action => 'edit')
    end
  end
  
end
