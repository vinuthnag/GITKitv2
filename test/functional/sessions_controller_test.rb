require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end
  
test "should get new" do
    get :new
    assert_response :success
  end

  test "should get login" do
    get :login
    assert_response :success
  end

  test "should get logout" do
    get :logout
    assert_response :success
  end

  test "should get user_status" do
    get :user_status
    assert_response :success
  end

  test "should get toolkit_oauth_callback" do
    get :toolkit_oauth_callback
    assert_response :success
  end
end
