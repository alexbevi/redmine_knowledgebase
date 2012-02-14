class CategoriesController < KnowledgebaseController
	unloadable

  #Authorize against global permissions defined in init.rb
  before_filter :authorize_global

  def show
    @category = KbCategory.find(params[:id])
    @articles = @category.articles.find(:all)
  end

  def new
    @category = KbCategory.new
    @parent_id = params[:parent_id]
  end

  def create
    @category = KbCategory.new(params[:category])
    if @category.save
      # Test if the new category is a root category, and if more categories exist.
      # We check for a value > 1 because if this is the first entry, the category
      # count would be 1 (since the create operation already succeeded)
      if !params[:root_category] and KbCategory.count > 1
        @category.move_to_child_of(KbCategory.find(params[:parent_id]))
      end

      flash[:notice] = l(:label_category_created, :title => @category.title)
      redirect_to({ :action => 'show', :id => @category.id })
    else
      render(:action => 'new')
    end
  end

  def edit
    @category = KbCategory.find(params[:id])
  end

  def destroy
    @category = KbCategory.find(params[:id])
    if @category.articles.size == 0
      @category.destroy
      flash[:notice] = l(:label_category_deleted)
      redirect_to({ :controller => :knowledgebase, :action => 'index' })
    else
      @articles = @category.articles.find(:all)
      flash[:error] = l(:label_category_not_empty_cannot_delete)
      render(:action => 'show')
    end
  end

  def update
    @category = KbCategory.find(params[:id])
    if !params[:root_category]
      @category.move_to_child_of(KbCategory.find(params[:parent_id]))
    end
    if @category.update_attributes(params[:category])
      flash[:notice] = l(:label_category_updated)
      redirect_to({ :action => 'show', :id => @category.id })
    else
      render(:action => 'edit')
    end
  end

end

