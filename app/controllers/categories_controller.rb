class CategoriesController < ApplicationController
	unloadable
	
  def index
		@categories = Category.find(:all)
  end
  
end
