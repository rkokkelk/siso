require 'test_helper'

class MainControllerTest < ActionController::TestCase

  test 'should get to repository new' do
    get :index
    assert_redirected_to(:controller => :repositories, :action => :new)
  end
end
