require 'test_helper'

class MainControllerTest < ActionController::TestCase
  test 'should get index' do
    get :index
    assert_redirected_to(:controller => 'repositories', :action => 'new')
  end

end
