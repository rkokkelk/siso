require 'test_helper'

class AttackerFlowTest < ActionDispatch::IntegrationTest

  test 'do not show new repository when originating from invalid IP' do
    # Perform get request from unauthenticated IP
    request_via_redirect('GET', '/', nil, { 'REMOTE_ADDR' => '::1' } )
    assert_response :success
    assert_template 'main/index'
  end

  test 'show new repository when originating from valid IP' do
    request_via_redirect('GET', '/', nil, { 'REMOTE_ADDR' => '254.254.254.254' } )
    assert_template 'repositories/new'
  end

  test 'brute-force attack on authentication' do
    @repo1 = repositories(:one)
    num_attacks = 25

    num_attacks.times do |number|
      request_via_redirect('POST', "/#{@repo1.token}/authenticate", { password: '1' }, { 'REMOTE_ADDR' => '254.254.254.254' } )

      assert_template 'main/server_error' if number == (num_attacks-1)
      assert_template 'repositories/authenticate' if number == 1
    end
  end

  test 'brute-force attack on create repository' do
    @repo1 = repositories(:one)
    num_attacks = 35

    num_attacks.times do |number|
      #post('/new', repository: { password: '', password_confirmation: '', description: '', title: 'test' }, 'REMOTE_ADDR' => '::1')
      #get(@response.location, nil, 'REMOTE_ADDR' => '::1')
      request_via_redirect('POST', '/new',
                           { repository: { password: '', password_confirmation: '', description: '', title: 'test' }},
                           { 'REMOTE_ADDR' => '254.254.254.254' } )

      assert_template 'main/server_error' if number == (num_attacks-1)
      assert_template 'repositories/show' if number == 1
    end
  end
end
