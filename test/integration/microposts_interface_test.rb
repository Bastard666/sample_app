require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @michael = users :michael
  end

  test "home page after logging in display user information and microposts feed" do
    log_in_as @michael
    # Going to home page after logging in
    get root_url
    # Checking the presence of the microposts' pagination 
    assert_select 'h1', text: @michael.name
    assert_select 'a[href = ?]', user_path(@michael)
    assert_select 'span', text: "#{@michael.microposts.count} microposts"
    assert_select 'div.field'
    assert_select 'h3', text: 'Micropost Feed'
    assert_select 'li', id: /\Amicropost-\d+\z/i
    assert_select 'span.user'
    assert_select 'span.content'
    assert_select 'span.timestamp'
    assert_select 'span.timestamp>a', text: 'delete'
    assert_select 'div.pagination'
  end

  test "Post of an invalid micropost should return a error message" do
    log_in_as @michael
    # Going to home page after logging in
    get root_url
    # Post of an invalid micropost
    assert_no_difference 'Micropost.count' do
      post microposts_path, micropost: { content: "" }
    end
    assert_select 'div#error_explanation'
  end

  test "Post of a valid micropost should save it then redirect to home page and show the micropost" do
    log_in_as @michael
    # Going to home page after logging in
    get root_url
    # Post of a valid micropost
    content = "This micropost really ties the room together"
    assert_difference 'Micropost.count', 1 do
      post microposts_path, micropost: { content: content }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
  end

  test "Deleting a post should decrease micropost count and redirect to the home page" do
    log_in_as @michael
    # Going to home page after logging in
    get root_url
    # Delete a post
    assert_select 'a', text: 'delete'
    first_micropost = @michael.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_no_match first_micropost.content, response.body
  end

  test "User should not be able to delete another user post" do
    log_in_as @michael
    # Going to another user's page
    get user_path(users :archer)
    assert_template 'users/show'
    assert_select 'a', text: 'delete', count: 0
  end
end
