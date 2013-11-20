require File.dirname(__FILE__) + '/../test_helper'

class ArticlesControllerTest < ActionController::TestCase
  fixtures :projects
  plugin_fixtures :kb_articles

  def setup
    Project.find(1).enable_module! :knowledgebase
  end

  def test_index
    @request.session[:user_id] = 1
    get :index, :project_id => 1

    assert_response :success
    assert_template 'index'
  end
end
