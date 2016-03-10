require 'test_helper'

class RelationshipsControllerTest < ActionController::TestCase
  test "following action should redirect to login url if not logged in" do
    assert_no_difference 'Relationship.count' do
      post :create
    end
    assert_redirected_to login_url
  end

  test "unfollowing action should redirect to login url if not logged in" do
    assert_no_difference 'Relationship.count' do
      delete :destroy, id: relationships(:one)
    end
    assert_redirected_to login_url
  end
end
