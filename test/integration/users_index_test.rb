require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = User.create(name: "User1",
                       email: "user1@test.com",
                       password: "password", password_confirmation: "password",
                       admin: true)
    @user2 = User.create(name: "User2",
                        email: "user2@test.com",
                        password: "password", password_confirmation: "password")
    @user3 = User.create(name: "User3",
                        email: "user3@test.com",
                        password: "password", password_confirmation: "password")
    @user4 = User.create(name: "User4",
                        email: "user4@test.com",
                        password: "password", password_confirmation: "password")
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
