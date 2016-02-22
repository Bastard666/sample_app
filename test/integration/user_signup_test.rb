require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "valid signup informations with account activation" do
    get signup_path
    # Assert user created and saved
    assert_difference 'User.count', 1 do
      post users_path, user: {  name: "Valid User",
                              email: "valid.user@test.org",
                              password: "password",
                              password_confirmation: "password" }
    end

    # Checking mail sent and user still not activated
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # Assert user view is rendered with a success message
    follow_redirect!
    assert_template 'static_pages/home'
    assert_not flash.empty?
    assert_equal flash[:info], "Please check your email to activate your account."
    assert_not is_logged_in?
    # Try to log in before activation.
    log_in_as(user)
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path("invalid token")
    assert_not is_logged_in?
    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
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
