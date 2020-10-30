require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
 
  def setup
    @post = posts(:superman)
    @non_admin = users(:user2)
    @comment = comments(:comment2)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Comment.count' do
      post comments_path, params: { comment: { content: "Lorem ipsum", post_id: @post.id } }
    end
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect destroy when not admin" do
    log_in_as(@non_admin)
    assert_no_difference 'Comment.count' do
      delete comment_path(@comment)
    end
    assert_not flash.empty?
    assert_redirected_to root_url
  end
end
