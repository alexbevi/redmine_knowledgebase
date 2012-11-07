class CategoriesController < KnowledgebaseController
	unloadable

  before_filter :find_project, :authorize

  def find_project
    if !params[:project_id].nil?
        @project=Project.find(params[:project_id])
    elsif !params[:category_id].nil?
        @project=KbCategory.find(params[:category_id]).project
    elsif !params[:parent_id].nil?
        @project=KbCategory.find(params[:parent_id]).project
    elsif !params[:id].nil?
        @project=KbCategory.find(params[:id]).project
    end
  end
  
  def show
    @category = KbCategory.find(params[:id])
    @articles = @category.articles.find(:all)
	@categories=@project.categories.find(:all)
  end

  def new
    @category = KbCategory.new
    @parent_id = params[:parent_id]
    @categories=@project.categories.find(:all)
  end

  def create
    @category = KbCategory.new(params[:category])
    @category.project_id=@project.id
    if @category.save
      # Test if the new category is a root category, and if more categories exist.
      # We check for a value > 1 because if this is the first entry, the category
      # count would be 1 (since the create operation already succeeded)
      if !params[:root_category] and @project.categories.count > 1
        @category.move_to_child_of(KbCategory.find(params[:parent_id]))
      end

      flash[:notice] = l(:label_category_created, :title => @category.title)
      redirect_to({ :action => 'show', :id => @category.id, :project_id => @project })
    else
      render(:action => 'new')
    end
  end

  def edit
    @category = KbCategory.find(params[:id])
    @parent_id = @category.parent_id
    @categories=@project.categories.find(:all)
  end

  def destroy
    @category = KbCategory.find(params[:id])
	@categories=@project.categories.find(:all)
    if @category.articles.size == 0
	  @category.destroy
      flash[:notice] = l(:label_category_deleted)
      redirect_to({ :controller => :knowledgebase, :action => 'index', :project_id => @project})
    else
      @articles = @category.articles.find(:all)
      flash[:error] = l(:label_category_not_empty_cannot_delete)
      render(:action => 'show')
    end
  end

  def update
    @category = KbCategory.find(params[:id])
    if params[:root_category] == "yes"
      @category.parent_id = nil
    else
      @category.move_to_child_of(KbCategory.find(params[:parent_id]))
    end

    if @category.update_attributes(params[:category])
      flash[:notice] = l(:label_category_updated)
      redirect_to({ :action => 'show', :id => @category.id, :project_id => @project })
    else
      render :action => 'edit'
    end
  end

end

