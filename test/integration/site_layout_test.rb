require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @michael = users :michael
  end

  test "layout links when not logged in" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path,   count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", users_path,  count: 0
    assert_select "a", text: "Profile",     count: 0
    assert_select "a", text: "Settings",    count: 0
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    get signup_path
    assert_select "title", full_title("Sign up")
  end

  test "layout links when logged in" do
    log_in_as @michael
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path,   count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", login_path,  count: 0
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", '#',         text: "Account"
    assert_select "a[href=?]", user_path(@michael)
    assert_select "a[href=?]", edit_user_path(@michael)
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
  end
end
