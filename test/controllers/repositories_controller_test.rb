require 'test_helper'

class RepositoriesControllerTest < ActionController::TestCase
  include CryptoHelper

  setup do
    @repository = repositories(:one)
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
      post :create, repository: { description: 'foobar', password: 'foobar!#FV8zc', title: 'foobar'}
    end

    assert_response :found
  end

  test 'should show repository' do

    iv = b64_decode @repository.iv_enc
    key = pbkdf2(iv,'pass1')
    master_key = decrypt_aes_256(iv, key, @repository.master_key_enc)

    session[@repository.token] = b64_encode master_key
    get :show, id: @repository.token

    assert_not_nil assigns(:repository)
    assert_response :success
  end

  test 'should not show repository' do
    assert_raises(SecurityError) do
      get :show, id: @repository
    end
  end

  test 'should not get edit' do
    assert_raises(ActionController::UrlGenerationError) do
      get :edit, id: @repository
    end
  end

  test 'should not update repository' do
    assert_raises(ActionController::UrlGenerationError) do
      patch :update, id: @repository, repository: { creation: @repository.creation, deletion: @repository.deletion, description: @repository.description, iv: @repository.iv, master_key: @repository.master_key, password: @repository.password, title: @repository.title, token: @repository.token }
    end
  end

  test 'should not destroy repository' do
    assert_raises(ActionController::UrlGenerationError) do
      assert_difference('Repository.count', -1) do
        delete :destroy, id: @repository
      end
      assert_response :failure
    end
  end
end
