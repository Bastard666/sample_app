require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @michael = users :michael
  end

  test "unsuccessful edit" do
    # Logging in
    log_in_as @michael
    # Accessing user edit page
    get edit_user_path(@michael)
    assert_template 'users/edit'
    # Editing profile with invalid information
    patch user_path(@michael), user: {  name:    "",
                                      email:  "foo@invalid",
                                      password:               "foo",
                                      password_confirmation:  "bar" }
    # Checking user edit page with error messages
    assert_template 'users/edit'
    assert_select 'div[id="error_explanation"]' do
      # assert_select "div", 1
      assert_select "ul>li", 4
    end
    assert_select 'div[class="alert alert-danger"]'
  end

  test "successful edit" do
    # Log in
    log_in_as @michael
    # Accessing user edit page
    get edit_user_path(@michael)
    assert_template 'users/edit'
    # Editing profile
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@michael), user: {  name:   name,
                                        email:  email,
                                        password:               "",
                                        password_confirmation:  "" }
    # Checking modification confirmation message presence
    assert_not flash.empty?
    # Checking redirection to user page
    assert_redirected_to @michael
    # Checking user modification have benn saved
    @michael.reload
    assert_equal name, @michael.name
    assert_equal email, @michael.email
  end

  test "successful edit with frienly forwarding" do
    # Trying to access user edit page without being logged in
    get edit_user_path(@michael)
    # Checking redirection to login page
    assert_redirected_to login_path
    # Checking friendly forwarding url is stored in session
    assert_not_nil session[:forwarding_url]
    # Log in
    log_in_as @michael
    # Checking redirection thanks to friendly forwarding
    assert_redirected_to edit_user_path(@michael)
    # Checking forwarding url is deleted from session after redirection
    assert_nil session[:forwarding_url]
    # Editing profile
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@michael), user: {  name:   name,
                                        email:  email,
                                        password:               "",
                                        password_confirmation:  "" }
    # Checking confirmation message presence after edition
    assert_not flash.empty?
    # Checking redirection to user page
    assert_redirected_to @michael
    # Checking modifications have been saved
    @michael.reload
    assert_equal name, @michael.name
    assert_equal email, @michael.email
  end
end
