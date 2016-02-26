require 'test_helper'

class UserShowTest < ActionDispatch::IntegrationTest
  
  def setup
    @michael = users :michael
    @archer = users :archer
  end

  test "non activated user page redirects to root url" do
    log_in_as @michael
    get user_path @archer
    assert_template 'users/show'
    @archer.toggle!(:activated)
    get user_path @archer
    assert_redirected_to root_url
  end
end
