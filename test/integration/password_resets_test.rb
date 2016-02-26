require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end

  test "should not allow empty email for password reset request" do
    # Going to ask for a password reset
    get new_password_reset_path
    assert_template 'password_resets/new'
    # Indicating an invalid email
    post password_resets_path, password_reset: { email: "" } 
    assert_not flash.empty?
    assert_template 'password_resets/new'
  end

  test "new form should redirect to root url and send reset email if email is valid" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    # Indicating a valid email
    post password_resets_path, password_reset: { email: @user.email }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect to root url if user is empty in edit password reset url" do
    # Going to ask for a password reset
    get new_password_reset_path
    assert_template 'password_resets/new'
    # Indicating a valid email
    post password_resets_path, password_reset: { email: @user.email }
    # Going to password reset page with an invalid token
    user = assigns(:user)
    # Wrong email
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url
  end

  test "should redirect to root url if user is not activated in edit password reset url" do
    # Going to ask for a password reset
    get new_password_reset_path
    assert_template 'password_resets/new'
    # Indicating a valid email
    post password_resets_path, password_reset: { email: @user.email }
    # Going to password reset page with an invalid token
    user = assigns(:user)
    # Inactive user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
  end

  test "should redirect to root url if reset token is invalid in edit password reset url" do
    # Going to ask for a password reset
    get new_password_reset_path
    assert_template 'password_resets/new'
    # Indicating a valid email
    post password_resets_path, password_reset: { email: @user.email }
    # Going to password reset page with an invalid token
    user = assigns(:user)
    # Wrong token
    get edit_password_reset_path('wrong_token', email: user.email)
    assert_redirected_to root_url
  end

  test "edit form should be shown if reset url is valid" do
    # Going to ask for a password reset
    get new_password_reset_path
    assert_template 'password_resets/new'
    # Indicating a valid email
    post password_resets_path, password_reset: { email: @user.email }
    # Going to password reset page with an invalid token
    user = assigns(:user)
    # Going to password reset page with right token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email
  end

  test "edit form should return an error if new password and confirmation are different" do
    # Going to ask for a password reset
    get new_password_reset_path
    assert_template 'password_resets/new'
    # Indicating a valid email
    post password_resets_path, password_reset: { email: @user.email }
    # Going to password reset page with an invalid token
    user = assigns(:user)
    # Going to password reset page with right token
    get edit_password_reset_path(user.reset_token, email: user.email)
    # Invalid password and confirmation
    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password:               "foobaz",
                  password_confirmation:  "barquux" }
    assert_template 'password_resets/edit'
    assert_select 'div#error_explanation'
  end

  test "edit form should return an error if new password is empty" do
    # Going to ask for a password reset
    get new_password_reset_path
    assert_template 'password_resets/new'
    # Indicating a valid email
    post password_resets_path, password_reset: { email: @user.email }
    # Going to password reset page with an invalid token
    user = assigns(:user)
    # Going to password reset page with right token
    get edit_password_reset_path(user.reset_token, email: user.email)
    # Empty password
    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password:               "",
                  password_confirmation:  "" }
    assert_template 'password_resets/edit'
    assert_select 'div#error_explanation'
  end

  test "edit form should redirect to logged in user after valid password reset" do
    # Going to ask for a password reset
    get new_password_reset_path
    assert_template 'password_resets/new'
    # Indicating a valid email
    post password_resets_path, password_reset: { email: @user.email }
    # Going to password reset page with an invalid token
    user = assigns(:user)
    # Going to password reset page with right token
    get edit_password_reset_path(user.reset_token, email: user.email)
    # Valid password and confirmation
    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password:               "foobaz",
                  password_confirmation:  "foobaz" }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end
end
