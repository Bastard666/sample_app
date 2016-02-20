require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = users :michael
    @non_admin = users :archer
  end

  test "index as admin including pagination and delete links" do
    log_in_as @admin
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      delete_link_presence = user == @admin ? 0 : 1
      assert_select 'a[href=?]', user_path(user), text: "delete", count: delete_link_presence
    end
    assert_difference 'User.count', -1 do
      delete_via_redirect user_path(@non_admin)
    end
    assert_template 'users/index'
  end

  test "index as non admin including pagination without delete links" do
    log_in_as @non_admin
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      assert_select 'a[href=?]', user_path(user), text: "delete", count: 0
    end
  end

end
