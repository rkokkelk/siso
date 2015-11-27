require 'test_helper'

class MainControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get create_repo" do
    get :create_repo
    assert_response :success
  end

end
