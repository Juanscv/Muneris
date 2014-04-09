require 'test_helper'

class UserControllerTest < ActionController::TestCase
  test "should get feed" do
    get :feed
    assert_response :success
  end

  test "should get notifications" do
    get :notifications
    assert_response :success
  end

end
