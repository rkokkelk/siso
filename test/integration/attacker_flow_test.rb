require 'test_helper'

class AttackerFlowTest < ActionDispatch::IntegrationTest

  test 'do not show new repository when originating from invalid IP' do
    # Perform get request from unauthenticated IP
    get('/', nil, 'REMOTE_ADDR' => '::1')
    assert_response :success
    assert_template 'main/index'
  end

  test 'bruteforce attack on authentication' do
    @repo1 = repositories(:one)

    20.times do |number|
      post "/#{@repo1.token}/authenticate", password: '1', 'REMOTE_ADDR' => '254.254.254.254'

      if number == 20
        assert_response :error
        assert_template 'main/server_error'
      else
        assert_template 'repositories/authenticate'
      end
    end
  end

  test 'bruteforce attack on create repository' do
    @repo1 = repositories(:one)

    30.times do |number|
      post_via_redirect('/new', repository: { password: '', password_confirm: '', description: '', title: 'test' }, 'REMOTE_ADDR' => '254.254.254.254')

      if number == 30
        assert_template 'main/server_error'
      else
        assert_template 'repositories/show'
      end
    end
  end
end
