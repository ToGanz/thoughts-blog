require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  def setup
    @user = User.create(name: "User1",
                     email: "user1@test.com",
                     password: "password", password_confirmation: "password")
  end

  test "password_reset" do
    @user.reset_token = User.new_token
    mail = UserMailer.password_reset(@user)
    assert_equal "Password reset", mail.subject
    assert_equal [@user.email], mail.to
    assert_equal ["noreply@thoughts.com"], mail.from
    assert_match @user.reset_token,        mail.body.encoded
    assert_match CGI.escape(@user.email),  mail.body.encoded
  end

end
