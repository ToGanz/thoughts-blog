require 'test_helper'

class PostsCreationTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:tobi)
  end

  test "creating a valid post" do
    get new_post_path
    assert_response :redirect
    log_in_as(@user)
    get new_post_path
    assert_response :success
    assert_difference 'Post.count', 1 do
      post posts_path, params: { post: { title: "test1", content: "test with enough length"} }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_template 'posts/show'
    assert_match "test1", response.body
  end

  test "invalid post parameters" do
    log_in_as(@user)
    get signup_path
    assert_response :success
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { title: " ", content: "te"} }
    end
    assert_match 'errors', response.body
    assert_select 'div.alert'
  end

end
