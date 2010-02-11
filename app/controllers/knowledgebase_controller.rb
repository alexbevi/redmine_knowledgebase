class KnowledgebaseController < ApplicationController

  def index
		@categories = Category.find(:all)
  end
end
