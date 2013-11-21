require File.dirname(__FILE__) + '/../test_helper'

class ArticlesControllerTest < ActionController::TestCase
  fixtures :projects
  plugin_fixtures :kb_articles, :enabled_modules

  def setup
    @request.session[:user_id] = 1
    @project = Project.find(1)
  end

  def test_index
    get :index, :project_id => @project.id

    assert_response :success
    assert_template 'index'
  end

end
