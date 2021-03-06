require 'test_helper'

class Settings::ProfilesControllerTest < ActionController::TestCase
  def setup
    @user = Factory :user
    create_site_config
  end

  def test_show
    get :show
    assert_redirected_to login_url

    login_as @user
    get :show
    assert_response :success, @response.body
  end

  def test_update
    put :update, :profile => {:name => 'change'}
    assert_redirected_to login_url
    
    login_as @user
    put :update, :profile => {:name => 'change'}
    assert_equal 'change', @user.profile.name
  end
end
