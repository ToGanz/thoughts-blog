require 'test_helper'

class CommentsCreationTest < ActionDispatch::IntegrationTest
  def setup
    @post = posts(:superman)
    @user = users(:user2)
  #  @comment = comments(:comment2)
  end

  test "creating a valid comment" do
    get post_path(@post)
    assert_response :success
    log_in_as(@user)
    assert_difference 'Comment.count', 1 do
      post comments_path, params: { comment: { content: "Comment content", post_id: @post.id } }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_template 'posts/show'
    assert_match "Comment content", response.body
  end


  test "invalid comment parameters" do
    log_in_as(@user)
    get post_path(@post)
    assert_response :success
    assert_no_difference 'Comment.count' do
      post comments_path, params: { comment: { content: " ", post_id: @post.id } }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_template 'posts/show'
  end
end
