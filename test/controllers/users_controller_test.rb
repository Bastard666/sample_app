require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
    @michael = users :michael
    @archer = users :archer
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_select "title", "Sign up | #{@base_title}"
  end

  test "should get show" do
    get :show, id: @michael
    assert_response :success
    assert_select "title", "#{@michael.name} | #{@base_title}"
  end

  test "should get edit" do
    log_in_as @michael
    get :edit, id: @michael
    assert_response :success
    assert_select "title", "Edit user | #{@base_title}"
  end

  test "should redirect edit when not logged in" do
    get :edit, id: @michael
    assert_redirected_to login_url
    assert_not flash.empty?
  end

  test "should redirect edit to home page for a different user" do
    log_in_as @archer
    get :edit, id: @michael
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should update and redirect to user page" do
    log_in_as @michael
    patch :update, id: @michael, user: { name: @michael.name, email: @michael.email }
    assert_response :redirect
    assert_redirected_to @michael
  end

  test "should redirect update when not logged in" do
    patch :update, id: @michael, user: { name: @michael.name, email: @michael.email }
    assert_redirected_to login_url
    assert_not flash.empty?
  end

  test "should redirect update to home page for a different user" do
    log_in_as @archer
    patch :update, id: @michael, user: { name: @michael.name, email: @michael.email }
    assert_redirected_to root_url
    assert flash.empty?
  end

  test "should redirect index to home page when not logged in" do
    get :index
    assert_redirected_to login_url
  end

  test "should display index page when logged in" do
    log_in_as @michael
    get :index
    assert_response :success
    assert_select "title", "All users | #{@base_title}"
  end

  test "should redirect delete to login page when not logged in" do
    assert_no_difference "User.count" do
      delete :destroy, id: @michael
    end
    assert_redirected_to login_url
  end

  test "should redirect delete to home page when not admin" do
    log_in_as @archer
    assert_no_difference "User.count" do
      delete :destroy, id: @michael
    end
    assert_redirected_to root_url 
  end

  test "should delete user when admin" do
    log_in_as @michael
    assert_difference "User.count", -1 do
      delete :destroy, id: @archer
    end
    assert_redirected_to users_url
  end

  test "should not allow the admin attribute to be accessed via the web" do
    log_in_as @archer
    assert_not @archer.admin?
    patch :update, id: @archer, user: { password:               "password",
                                        password_confirmation:  "password",
                                        admin:                  true }
    assert_not @archer.reload.admin?
  end

  test "should redirect following when not logged in" do
    get :following, id: @michael
    assert_redirected_to login_url
  end

  test "should redirect followers when not logged in" do
    get :followers, id: @michael
    assert_redirected_to login_url
  end

end
