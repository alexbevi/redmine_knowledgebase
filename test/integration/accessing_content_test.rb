require File.dirname(__FILE__) + '/../test_helper'

class AccessingContentTest < ActionController::IntegrationTest
  fixtures :projects, :users
  plugin_fixtures :kb_articles, :kb_categories
  def setup
    @project = Project.find(1)
    @user_1 = User.find(1)
    @user_2 = User.find(2)
  end
  
  test "access category with an explicit whitelist defined" do
    cat_wl = KbCategory.find(2)
    assert !cat_wl.user_whitelist.blank?, "Category Whitelist expected to be populated"

    assert !cat_wl.blacklisted?(@user_1), "User 1 is supposed to be whitelisted"
    assert cat_wl.blacklisted?(@user_2), "User 2 is supposed to not be whitelisted"
  end
end