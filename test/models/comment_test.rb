require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  def setup
    @user = users(:tobi)
    @post = posts(:superman)
    @comment = @post.comments.build(user_id: @user.id, content: "Nice Post!")
  end

  test "should be valid" do
    assert @comment.valid?
  end

  test "post id should be present" do
    @comment.post_id = nil
    assert_not @comment.valid?
  end

  test "user id should be present" do
    @comment.user_id = nil
    assert_not @comment.valid?
  end

  test "content should be present" do
    @comment.content = "         "
    assert_not @comment.valid?
  end

  test "order should be most recent last" do
    assert_equal comments(:most_recent), Comment.last
  end

  test "comment on post should increase after save" do
    assert_equal @post.total_comments_count, 0
    @comment.save!
    @post.reload
    assert_equal @post.total_comments_count, 1
  end
end
