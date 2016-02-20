require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest
  test "valid signup informations" do
    get signup_path

    # Assert user created and saved
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: {  name: "Valid User",
                              email: "valid.user@test.org",
                              password: "password",
                              password_confirmation: "password" }
    end

    # Assert user view is rendered with a success message
    assert_template 'users/show'
    assert_not flash.empty?
    assert is_logged_in?
  end

  test "invalid signup informations" do
    get signup_path

    # Assert user was not savec
    assert_no_difference 'User.count' do
      post users_path, user: {  name: "",
                                email: "user@invalid",
                                password: "foo",
                                password_confirmation: "bar" }
    end

    # Assert view for signup is rendered with error messages
    assert_template 'users/new'
    assert_select 'div[id="error_explanation"]' do
      # assert_select "div", 1
      assert_select "ul>li", 4
    end
    assert_select 'div[class="alert alert-danger"]'
  end
end
