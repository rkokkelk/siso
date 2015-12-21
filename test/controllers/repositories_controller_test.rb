require 'test_helper'

class RepositoriesControllerTest < ActionController::TestCase
  include CryptoHelper

  setup do
    @repo1 = repositories(:one)
    @repo2 = repositories(:two)
  end

  test 'should not get index' do
    assert_raises(ActionController::UrlGenerationError) do
      get :index
    end
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create repository' do
    assert_difference('Repository.count') do
      post :create, repository: { description: 'foobar', password: '!@$!@$#@%SDFGVXCB',password_confirm: '!@$!@$#@%SDFGVXCB', title: 'foobar'}
    end

    assert_response :found

    assert_difference('Repository.count') do
      post :create, repository: { description: '', password: '!@$!@$#@%SDFGVXCB',password_confirm: '!@$!@$#@%SDFGVXCB', title: 'foobar'}
    end

    assert_response :found
  end

  test 'should not create repository' do
    assert_no_difference('Repository.count') do
      post :create, repository: { description: 'foobar', password: '123',password_confirm: '123', title: 'foobar'}
    end

    assert_no_difference('Repository.count') do
      post :create, repository: { description: '', password: '!@$!@$#@%SDFGVXCB',password_confirm: '!@$!@$#@%SDFGVXCB', title: 't!@#'}
    end

    assert_no_difference('Repository.count') do
      post :create, repository: { description: '<>asdfij!@#5', password: '!@$!@$#@%SDFGVXCB',password_confirm: '!@$!@$#@%SDFGVXCB', title: 'foobar'}
    end

    assert_no_difference('Repository.count') do
      post :create, repository: { description: '', password: '!@$!@$#@%SDFGVXCB',password_confirm: '!@$!@$#@%SDFGVXCB', title: ''}
    end

    assert_no_difference('Repository.count') do
      post :create, repository: { description: 'test', password: '',password_confirm: '', title: 'test'}
    end
  end

  test 'should show repository' do

    iv = b64_decode @repo1.iv_enc
    key = pbkdf2(iv,')O(I*U&Y%R$E')
    master_key = decrypt_aes_256(iv, key, @repo1.master_key_enc)

    session[@repo1.token] = b64_encode master_key
    get :show, id: @repo1.token

    assert_not_nil assigns(:repository)
    assert_response :success
  end

  test 'should not show repository' do
    get :show, id: @repo1.token
    assert_template :authenticate

    iv = b64_decode @repo1.iv_enc
    key = pbkdf2(iv,')O(I*U&Y%R$E')
    master_key = decrypt_aes_256(iv, key, @repo1.master_key_enc)

    session[@repo1.token] = b64_encode master_key
    get :show, id: @repo2.token

    assert_nil assigns(:repository)
    assert_template :authenticate
  end

  test 'should redirect user to repository' do
    post :authenticate, id: @repo1.token, password: ')O(I*U&Y%R$E'
    assert_not_nil session[@repo1.token]
    assert_redirected_to(:controller => 'repositories', :action => 'show', :id => @repo1.token)
  end

  test 'should not redirect user to repository' do

    post :authenticate, id: @repo1.token, password: 'foobar'
    assert_nil session[@repo1.token]
    assert_template :authenticate
    assert_equal 'Login failed. Please verify the correct URL and password.', flash[:alert]

    post :authenticate, id: 'ASBCDFQWELIUDFASD', password: 'foobar'
    assert_nil session['ASBCDFQWELIUDFASD']
    assert_template :authenticate
    assert_equal 'Login failed. Please verify the correct URL and password.', flash[:alert]
  end

  test 'should not get edit' do
    assert_raises(ActionController::UrlGenerationError) do
      get :edit, id: @repo1
    end
  end

  test 'should not update repository' do
    assert_raises(ActionController::UrlGenerationError) do
      patch :update, id: @repo1, repository: { creation: @repo1.creation, deletion: @repo1.deletion, description: @repo1.description, iv: @repo1.iv, master_key: @repo1.master_key, password: @repo1.password, title: @repo1.title, token: @repo1.token }
    end
  end

  test 'should not destroy repository' do
    assert_raises(ActionController::UrlGenerationError) do
      assert_difference('Repository.count', -1) do
        delete :destroy, id: @repo1
      end
      assert_response :failure
    end
  end
end
