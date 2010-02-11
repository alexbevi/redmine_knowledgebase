class KnowledgebaseController < ApplicationController
  unloadable
  
  def index
		@categories = Category.find(:all)
  end

end
