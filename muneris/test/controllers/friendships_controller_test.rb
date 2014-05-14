require 'test_helper'

class FriendshipsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get update" do
    get :update
    assert_response :success
  end

  test "should get requests" do
    get :requests
    assert_response :success
  end

  test "should get invites" do
    get :invites
    assert_response :success
  end

  test "should get destroy" do
    get :destroy
    assert_response :success
  end

end
