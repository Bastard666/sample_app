require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @michael = users :michael
    @micropost = @michael.microposts.build(content: "lorem ipsum")
  end

  test "valid micropost" do
    assert @micropost.valid?
  end

  test "user id should be present in a micropost" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "micropost should have non blank content" do
    @micropost.content = " " * 10
    assert_not @micropost.valid?
  end

  test "micropost should have content of 140 characters max" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  test "user microposts should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end
end
