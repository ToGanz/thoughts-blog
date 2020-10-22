require 'test_helper'

class EditPostTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:tobi)
    @post = posts(:orange)
  end

  test "edit with valid parameters" do
    get edit_post_path(@post)
    assert_response :redirect
    log_in_as(@user)
    get edit_post_path(@post)
    assert_response :success
    title = "blue"
    content = "i ate a blue orange today"
    patch post_path(@post), params: { post: { title:  title,
                                      content: content } }
    follow_redirect!
    assert_response :success
    assert_template 'posts/show'
    @post.reload
    assert_equal title,  @post.title
    assert_equal content, @post.content
  end

  test "invalid post parameters" do
    log_in_as(@user)
    get edit_post_path(@post)
    assert_response :success
    patch post_path(@post), params: { post: { title:  " ",
                                      content: "i aate"} }
    assert_template 'posts/edit'
    assert_match 'errors', response.body
    assert_select 'div.alert'
  end
end
