require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
 
  def setup
    @user = users(:tobi)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'h2', text: @user.name
    assert_match @user.posts.count.to_s, response.body
    assert_select 'div.pagination'
    @user.posts.paginate(page: 1).each do |post|
      assert_match post.title, response.body
      assert_match post.content, response.body
    end
  end

end
