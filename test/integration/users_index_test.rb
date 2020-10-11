require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = User.create(name: "User1",
                       email: "user1@test.com",
                       password: "password", password_confirmation: "password")
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
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    assert_select 'a[href=?]', user_path(@user), text: @user.name

  end

end
