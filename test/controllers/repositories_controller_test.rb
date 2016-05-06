require 'test_helper'

class RepositoriesControllerTest < ActionController::TestCase
  include CryptoHelper

  setup do
    @repo1 = repositories(:one)
    @repo2 = repositories(:two)

    # Set valid session for repo1
    iv = b64_decode @repo1.iv_enc
    key = pbkdf2(iv,')O(I*U&Y%R$E')
    master_key = decrypt_aes_256(iv, key, @repo1.master_key_enc)
    session[@repo1.token] = b64_encode master_key

    # Copy record files to data folder
    FileUtils.cp(Dir.glob('test/fixtures/assets/*.file'),'data/')
  end

  test 'should not get index' do
    assert_raises(ActionController::UrlGenerationError) do
      get :index
    end
  end

  test 'should redirect due to invalid token' do
    get :show, id: 'a'
    assert_not_nil flash[:alert]
    assert_redirected_to controller: :main, action: :index

    get :show, id: @repo1.token+'%'
    assert_not_nil flash[:alert]
    assert_redirected_to controller: :main, action: :index
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create repository' do
    pass = '!@$!@$#@%SDFGVXCB'

    assert_difference('Repository.count') do
      post :create, repository: { description: 'foobar', password: pass, password_confirmation: pass, title: 'foobar'}
    end
    assert_response :redirect

    assert_difference('Repository.count') do
      post :create, repository: { description: '', password: pass, password_confirmation: pass, title: 'foobar'}
    end
    assert_response :redirect

    assert_difference('Repository.count') do
      post :create, repository: { description: '', password: '', password_confirmation: '', title: 'foobar'}
    end

    assert_response :redirect
    assert_not_nil flash[:alert]
    assert_not_nil flash[:notice]
  end

  test 'should not create repository' do
    # Weak Passwords
    assert_no_difference('Repository.count') do
      post :create, repository: { description: 'foobar', password: '123', password_confirmation: '123', title: 'foobar'}
    end

    # Invalid title
    assert_no_difference('Repository.count') do
      post :create, repository: { description: '', password: '!@$!@$#@%SDFGVXCB', password_confirmation: '!@$!@$#@%SDFGVXCB', title: 't!@#'}
    end

    # Invalid description
    assert_no_difference('Repository.count') do
      post :create, repository: { description: '<>asdfij!@#5', password: '!@$!@$#@%SDFGVXCB', password_confirmation: '!@$!@$#@%SDFGVXCB', title: 'foobar'}
    end

    # No title
    assert_no_difference('Repository.count') do
      post :create, repository: { description: '', password: '!@$!@$#@%SDFGVXCB', password_confirmation: '!@$!@$#@%SDFGVXCB', title: ''}
    end

    # Not equal passwords
    assert_no_difference('Repository.count') do
      post :create, repository: { description: '', password: '!@$!@$#@%SDFGVXCB', password_confirmation: '!@$', title: 'foobar'}
    end
  end

  test 'should show repository' do

    get :show, id: @repo1.token

    assert_not_nil assigns(:repository)
    assert_response :success
  end

  test 'should not show repository' do
    get :show, id: @repo2.token

    assert_nil assigns(:repository)
    assert_redirected_to action: :authenticate, id: @repo2.token
  end

  test 'should redirect user to repository' do
    post :authenticate, id: @repo2.token, password: ')O(I*U&Y%R$E'
    assert_not_nil session[@repo2.token]
    assert_redirected_to(:controller => 'repositories', :action => 'show', :id => @repo2.token)
  end

  test 'should not redirect user to repository' do

    post :authenticate, id: @repo2.token, password: 'foobar'
    assert_nil session[@repo2.token]
    assert_template :authenticate
    flash_1 = flash[:alert]

    post :authenticate, id: '0ef32b37113953c02229b7b1c48ce2f8', password: 'foobar'
    assert_nil session['0ef32b37113953c02229b7b1c48ce2f8']
    assert_template :authenticate
    flash_2 = flash[:alert]

    # Ensure no information leakage due to invalid password or token
    assert_equal flash_1, flash_2
  end

  test 'should delete the repository' do
    assert_difference('Repository.count', -1) do
      assert_difference('Record.count', -2) do
        delete :delete, id: @repo1.token
        assert_redirected_to(:controller => 'main', :action => 'index')
      end
    end
  end

  test 'should not destroy repository' do
    assert_no_difference('Repository.count') do
      assert_no_difference('Record.count') do
        delete :delete, id: @repo2.token
        assert_redirected_to(:controller => 'repositories', :action => 'authenticate', :id => @repo2.token)
      end
    end
  end

  test 'should not get edit' do
    assert_raises(ActionController::UrlGenerationError) do
      get :edit, id: @repo1
    end
  end

  test 'should not update repository' do
    assert_raises(ActionController::UrlGenerationError) do
      patch :update, id: @repo1, repository: { created_at: @repo1.created_at, deleted_at: @repo1.deleted_at, description: @repo1.description, iv: @repo1.iv, master_key: @repo1.master_key, password: @repo1.password, title: @repo1.title, token: @repo1.token }
    end
  end
end
