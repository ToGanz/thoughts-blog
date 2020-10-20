require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = users(:user1)
    @user2 = users(:user2)
 end

  test "index including pagination" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    assert_select 'a[href=?]', user_path(@admin), text: @admin.name
    assert_select 'a[href=?]', user_path(@user2), text: 'delete'
   
    assert_difference 'User.count', -1 do
      delete user_path(@user2)
    end
  end

  test "index as non-admin" do
    log_in_as(@user2)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

end
