require 'test_helper'

class RecordsControllerTest < ActionController::TestCase

  include CryptoHelper

  setup do
    @record1_1 = records(:repo1_one)
    @record1_2 = records(:repo1_two)
    @record2_1 = records(:repo2_one)
    @record2_2 = records(:repo2_two)
    @repo1 = repositories(:one)
    @repo2 = repositories(:two)

    # Set valid session for repo1
    iv = b64_decode @repo1.iv_enc
    key = pbkdf2(iv,')O(I*U&Y%R$E')
    master_key = decrypt_aes_256(iv, key, @repo1.master_key_enc)
    session[@repo1.token] = b64_encode master_key
  end

  test 'should get file' do
    iv = b64_decode @repo1.iv_enc
    key = pbkdf2(iv,')O(I*U&Y%R$E')
    master_key = decrypt_aes_256(iv, key, @repo1.master_key_enc)
    record_iv = b64_decode @record1_1.iv_enc

    #file_name = decrypt_aes_256(record_iv, master_key, @record1_1.file_name_enc)
    size = decrypt_aes_256(record_iv, master_key, @record1_1.size_enc)

    get :show, id: @repo1.token, record_id: @record1_1.token
    assert :success
    assert_equal response.body, "repo1_one\n"
    assert_equal String(response.body.size), size
    # assert_equal response.headers['filename'], file_name TODO: find a way to filter filename from Content-Disposition

    record_iv = b64_decode(@record1_2.iv_enc)
    #file_name = decrypt_aes_256(record_iv, master_key, @record1_2.file_name_enc)
    size = decrypt_aes_256(record_iv, master_key, @record1_2.size_enc)

    get :show, id: @repo1.token, record_id: @record1_2.token
    assert :success
    assert_equal response.body, "repo1_two\n"
    assert_equal String(response.body.size), size
    #assert_equal response.headers['filename'], file_name TODO: find a way to filter filename from Content-Disposition
  end

  test 'should not get file' do

    get :show, id: @repo1.token, record_id: @record2_1.token
    assert_redirected_to(:controller => 'repositories', :action => 'show', :id => @repo1.token)

    get :show, id: @repo2.token, record_id: @record1_1.token
    assert_redirected_to(:controller => 'repositories', :action => 'show', :id => @repo2.token)
  end

  #test 'should delete file' do TODO: find a way to verify this function without removing example data
  #end

  test 'should not delete file' do

    assert_no_difference('Record.count') do
      delete :delete, id: @repo2.token, record_id: @record1_2.token
      assert_redirected_to(:controller => 'repositories', :action => 'show', :id => @repo2.token)
    end

    assert_no_difference('Record.count') do
      delete :delete, id: @repo1.token, record_id: @record2_2.token
      assert_redirected_to(:controller => 'repositories', :action => 'show', :id => @repo1.token)
    end
  end

  test 'should put file' do

  end
end