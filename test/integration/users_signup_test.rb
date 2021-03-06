require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  

  test "creating a valid user" do
    get signup_path
    assert_response :success
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "test1", email: "test1@test.com",
                                 password: "password", password_confirmation: "password"} }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_template 'users/show'
    assert_match "test1", response.body
    assert is_logged_in?
  end

  test "invalid signup information" do
    get signup_path
    assert_response :success
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_match 'errors', response.body
    assert_select 'div.alert'
  end

end
