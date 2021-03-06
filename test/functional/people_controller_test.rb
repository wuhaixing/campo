require 'test_helper'

class PeopleControllerTest < ActionController::TestCase
  def setup
    @user = Factory :user
    @topic = Factory(:topic , :user => @user)
    create_site_config
  end

  test "should render banned when user had been band" do
    @user.ban!

    get :show, :username => @user.username
    assert_template :banned
    
  end

  test "should get statuses" do
    get :statuses, :username => @user.username
    assert_response :success, @response.body
  end

  test"should block user" do
    post :block, :username => @user.username
    assert_redirected_to login_url

    user_two = Factory :user
    login_as user_two
    assert_difference "@user.blockers.count" do
      assert_difference "user_two.blockings.count" do
        post :block, :username => @user.username
        assert_redirected_to person_url(:username => @user.username)
      end
    end
  end

  test "should unblock user" do
    delete :unblock, :username => @user.username
    assert_redirected_to login_url

    user_two = Factory :user
    user_two.block @user
    login_as user_two
    assert_difference "@user.blockers.count", -1 do
      assert_difference "user_two.blockings.count", -1 do
        delete :unblock, :username => @user.username
        assert_redirected_to person_url(:username => @user.username)
      end
    end
  end

  test "should follow user" do
    post :follow, :username => @user.username
    assert_redirected_to login_url

    user_two = Factory :user
    login_as user_two
    assert_difference "@user.followers.count" do
      assert_difference "user_two.followings.count" do
        post :follow, :username => @user.username
        assert_redirected_to person_url(:username => @user.username)
      end
    end
  end

  test "should unfollow user" do
    delete :unfollow, :username => @user.username
    assert_redirected_to login_url

    user_two = Factory :user
    user_two.follow @user
    login_as user_two
    assert_difference "@user.followers.count", -1 do
      assert_difference "user_two.followings.count", -1 do
        delete :unfollow, :username => @user.username
        assert_redirected_to person_url(:username => @user.username)
      end
    end
  end

  test "should get followings" do
    get :followings, :username => @user.username
    assert_response :success, @response.body
  end

  test "should get followers" do
    get :followers, :username => @user.username
    assert_response :success, @response.body
  end

  def test_show
    get :show, :username => @user.username
    assert_response :success, @response.body
  end

  def test_topics
    get :topics, :username => @user.username
    assert_response :success, @response.body

    get :topics, :username => @user.username, :format => :rss
    assert_response :success, @response.body
  end
end
