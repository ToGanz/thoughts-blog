require 'test_helper'

class PostInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:tobi)
  end

  test "post interface" do
    log_in_as(@user)
    get new_post_path
    assert_select 'input[type=file]'
    # Invalid submission
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { content: "" } }
    end
    assert_select 'div#error_explanation'
  # Valid submission
    title = "Room"
    content = "This post really ties the room together"
    image = fixture_file_upload('test/fixtures/kitten.jpg', 'image/jpeg')
    assert_difference 'Post.count', 1 do
      post posts_path, params: { post:
                              { title: title, content: content, image: image } }
    end
    assert assigns(:post).image.attached?
    follow_redirect!
    assert_match title, response.body
    assert_match content, response.body
    # Delete a post.
    assert_select 'a', text: 'delete'
    first_post = @user.posts.paginate(page: 1).first
    assert_difference 'Post.count', -1 do
      delete post_path(first_post)
    end
    # Visit a different user.
    get user_path(users(:user1))
    assert_select 'a', { text: 'delete', count: 0 }
  end
end
