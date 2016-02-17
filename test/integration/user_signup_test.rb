require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest
  test "valid signup informations" do
    get signup_path
    assert_difference 'User.count', 1 do
    post_via_redirect users_path, user: {  name: "Valid User",
                              email: "valid.user@test.org",
                              password: "password",
                              password_confirmation: "password" }
    end
    assert_template 'users/show'
  end

  test "invalid signup informations" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: {  name: "",
                                email: "user.invalid",
                                password: "foo",
                                password_confirmation: "bar" }
    end
    assert_template 'users/new'
  end
end
