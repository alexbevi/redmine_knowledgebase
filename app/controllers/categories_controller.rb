class CategoriesController < ApplicationController
  unloadable
  
  menu_item :articles
  helper :knowledgebase
  include KnowledgebaseHelper
  helper :watchers
  include WatchersHelper

  before_filter :find_project_by_project_id, :authorize
  before_filter :get_category, :only => [:show, :edit, :update, :destroy]
  accept_rss_auth :show

  rescue_from ActiveRecord::RecordNotFound, :with => :force_404
  
  def show
    @articles = @category.articles.order("#{sort_column} #{sort_direction}")
    @categories = @project.categories.where(:parent_id => nil)
    
    respond_to do |format|
      format.html { render :template => 'categories/show', :layout => !request.xhr? }
      format.atom { render_feed(@articles, :title => "#{l(:knowledgebase_title)}: #{l(:label_category)}: #{@category.title}") }
    end
  end

  def new
    @category = KbCategory.new
    @parent_id = params[:parent_id]
    @categories=@project.categories.all
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
    @parent_id = @category.parent_id
    @categories=@project.categories.all
  end

  def destroy
	  @categories=@project.categories.all
    if @category.articles.size == 0
	  @category.destroy
      flash[:notice] = l(:label_category_deleted)
      redirect_to({ :controller => :articles, :action => 'index', :project_id => @project})
    else
      @articles = @category.articles.find(:all)
      flash[:error] = l(:label_category_not_empty_cannot_delete)
      render(:action => 'show')
    end
  end

  def update
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

#######
private
#######
  
  def get_category
    @category = @project.categories.find(params[:id])
  end

  def force_404
    render_404
  end
end
