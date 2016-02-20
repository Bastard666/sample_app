require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @michael = users :michael
  end

  test "unsuccessful edit" do
    log_in_as @michael
    get edit_user_path(@michael)
    assert_template 'users/edit'
    patch user_path(@michael), user: {  name:    "",
                                      email:  "foo@invalid",
                                      password:               "foo",
                                      password_confirmation:  "bar" }
    assert_template 'users/edit'
    assert_select 'div[id="error_explanation"]' do
      # assert_select "div", 1
      assert_select "ul>li", 4
    end
    assert_select 'div[class="alert alert-danger"]'
  end

  test "successful edit" do
    log_in_as @michael
    get edit_user_path(@michael)
    assert_template 'users/edit'
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@michael), user: {  name:   name,
                                        email:  email,
                                        password:               "",
                                        password_confirmation:  "" }
    assert_not flash.empty?
    assert_redirected_to @michael
    @michael.reload
    assert_equal name, @michael.name
    assert_equal email, @michael.email
  end

  test "successful edit with frienly forwarding" do
    get edit_user_path(@michael)
    assert_redirected_to login_path
    log_in_as @michael
    assert_redirected_to edit_user_path(@michael)
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@michael), user: {  name:   name,
                                        email:  email,
                                        password:               "",
                                        password_confirmation:  "" }
    assert_not flash.empty?
    assert_redirected_to @michael
    @michael.reload
    assert_equal name, @michael.name
    assert_equal email, @michael.email
  end
end