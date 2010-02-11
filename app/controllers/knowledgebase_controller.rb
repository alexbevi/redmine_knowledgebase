class KnowledgebaseController < ApplicationController
  unloadable
  
  def index
		@categories = Category.find(:all)
    @articles_newest = Article.find(:all)
  end

end
