require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Setup for a valid user
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                      password: "foobar", password_confirmation: "foobar")
  end

  # Test for a valid user
  test "should be valid" do
    assert @user.valid?
  end

  # Tests for name validity on user
  test "name should be present" do
    @user.name = "       "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  # Tests for email validity on user
  test "email should be present" do
    @user.email = "      "
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com form foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = duplicate_user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email should be saved in lower case" do
    @user.email = mixed_case_email = "Foo@ExAMPle.CoM"
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  # Tests for password validity on user
  test "password should be present" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return true for a user with valid remember token" do
    token = User.new_token
    @user.remember_token = token
    @user.remember_digest = User.digest(token)
    assert @user.authenticated?(:remember, token)
  end

  test "authenticated? should return false for a user with invalid remember token" do
    token = User.new_token
    @user.remember_token = token
    @user.remember_digest = User.digest(token)
    assert_not @user.authenticated?(:remember, User.new_token)
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "authenticated? should return false for an invalid digest type" do
    assert_not @user.authenticated?('', '')
  end

  test "user microposts should be destroyed with him" do
    @user.save
    @user.microposts.create!(content: "lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

end
