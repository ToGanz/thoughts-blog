require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(first_name: "User1", last_name: "last",
                     email: "user1@test.com",
                     password: "password", password_confirmation: "password")
  end

  test "User should be valid" do
    assert @user.valid?
  end

end