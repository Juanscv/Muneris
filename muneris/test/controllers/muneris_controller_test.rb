require 'test_helper'

class MunerisControllerTest < ActionController::TestCase
  test "should get dashboard" do
    get :dashboard
    assert_response :success
  end

  test "should get profile" do
    get :profile
    assert_response :success
  end

  test "should get network" do
    get :network
    assert_response :success
  end

  test "should get map" do
    get :map
    assert_response :success
  end

end
