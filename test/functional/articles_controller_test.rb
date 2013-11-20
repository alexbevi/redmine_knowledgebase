require File.dirname(__FILE__) + '/../test_helper'

class ArticlesControllerTest < ActionController::TestCase
  fixtures :projects
  plugin_fixtures :kb_articles

  def setup
    Project.find(1).enable_module! :knowledgebase
  end

  test "should show index" do
    get :index, :project_id => 1

    assert_response :success
    assert_template 'index'
  end

end
