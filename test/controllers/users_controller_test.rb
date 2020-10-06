require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = User.new(name: "User1",
                     email: "user1@test.com",
                     password: "password", password_confirmation: "password")

    @user2 = User.new(name: "User2",
                      email: "user2@test.com",
                      password: "password", password_confirmation: "password")
  end

  test "should get index" do
    get users_path
    assert_response :success
  end

  test "should show user" do
    @user.save
    get user_url(@user)
    assert_response :success
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

end
