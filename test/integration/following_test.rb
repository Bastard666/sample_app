require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  def setup
    @michael = users :michael
    @archer = users :archer
    log_in_as @michael
  end

  test "following page" do
    get following_user_path(@michael)
    assert_template 'show_follow'
    # Checking followed users
    followed_users = @michael.following
    assert_not followed_users.empty?
    assert_select "strong[id='following']", text: followed_users.count.to_s
    followed_users.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
    # Checking followers
    followers = @michael.followers
    assert_not followers.empty?
    assert_select "strong[id='followers']", text: followers.count.to_s
    followers_not_followed = followers - followed_users
    assert_not followers_not_followed.empty?
    followers_not_followed.each do |user|
      assert_select "a[href=?]", user_path(user), count: 0
    end
  end

  test "followers page" do
    get followers_user_path(@michael)
    assert_template 'show_follow'
    # Checking followers
    followers = @michael.followers
    assert_not followers.empty?
    assert_select "strong[id='followers']", text: followers.count.to_s
    followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
    # Checking followed users
    followed_users = @michael.following
    assert_not followed_users.empty?
    assert_select "strong[id='following']", text: followed_users.count.to_s
    following_but_not_followed = followed_users - followers
    assert_not following_but_not_followed.empty?
    following_but_not_followed.each do |user|
      assert_select "a[href=?]", user_path(user), count: 0
    end
  end

  # Tests follow/unfollow actions without javascript
  test "following a user without js should increase his followers count and change to unfollow button" do
    assert_difference 'Relationship.count', 1 do
      post relationships_path, followed_id: @archer.id
    end
    follow_redirect!
    assert_template 'users/show'
    assert_select "input[type=?][value=?]", "submit", "Unfollow"
  end

  test "unfollowing a user without js should decrease his followers count and change to follow button" do
    @michael.follow @archer
    relationship = @michael.active_relationships.find_by(followed_id: @archer.id)
    assert_difference 'Relationship.count', -1 do
      delete relationship_path(relationship)
    end
    follow_redirect!
    assert_template 'users/show'
    assert_select "input[type=?][value=?]", "submit", "Follow"
  end

  # Tests follow/unfollow actions with javascript
  test "following a user with js should increase his followers count and change to unfollow button" do
    assert_difference 'Relationship.count', 1 do
      xhr :post, relationships_path, followed_id: @archer.id
    end
  end

  test "unfollowing a user with js should decrease his followers count and change to follow button" do
    @michael.follow @archer
    relationship = @michael.active_relationships.find_by(followed_id: @archer.id)
    assert_difference 'Relationship.count', -1 do
      xhr :delete, relationship_path(relationship)
    end
  end
end
