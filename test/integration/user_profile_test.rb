require 'test_helper'

class UserProfileTest < ActionDispatch::IntegrationTest

  def setup
    @michael = users :michael
  end

  test "profile display" do
    get user_path(@michael)
    assert_template 'users/show'
    assert_select 'title', full_title(@michael.name)
    assert_select 'h1', text: @michael.name
    assert_select 'h1>img.gravatar'
    assert_match @michael.microposts.count.to_s, response.body
    assert_select 'div.pagination'
    @michael.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end
end
