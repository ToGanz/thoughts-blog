require 'test_helper'

class PostTest < ActiveSupport::TestCase
  
  def setup
    @user = User.create(name: "User1",
      email: "user1@test.com",
      password: "password", password_confirmation: "password")

    # This code is not idiomatically correct.
    @post = Post.new(title: "Test post", content: "Lorem ipsum", user_id: @user.id)
  end

  test "should be valid" do
    assert @post.valid?
  end

  test "user id should be present" do
    @post.user_id = nil
    assert_not @post.valid?
  end

end
