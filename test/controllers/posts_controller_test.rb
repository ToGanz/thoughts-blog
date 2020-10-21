require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @post = posts(:orange)
  end

  test "should show post" do
    @post.save
    get post_path(@post)
    assert_response :success
  end

  test "should get index" do
    get posts_path
    assert_response :success
  end

  test "should redirect new when not logged in" do
    get new_post_path
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { title: "Lorem title", content: "Lorem ipsum" } }
    end
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when not logged in" do
    get edit_post_path(@post)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch post_path(@post), params: { user: { title: @post.title,
                                              content: @post.content } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Post.count' do
      delete post_path(@post)
    end
    assert_not flash.empty?
    assert_redirected_to login_url
  end
end
