require 'test_helper'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

class RecordsControllerTest < ActionController::TestCase
  include RecordsHelper
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

    # Copy record files to data folder
    FileUtils.cp(Dir.glob('test/fixtures/assets/*.file'),'data/')
  end

  test 'should get file' do
    master_key = b64_decode session[@repo1.token]
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
    assert_redirected_to(:controller => 'repositories', :action => 'authenticate', :id => @repo2.token)

    get :show, id: @repo2.token, record_id: @record2_1.token
    assert_redirected_to(:controller => 'repositories', :action => 'authenticate', :id => @repo2.token)
  end

  test 'should delete file' do
    assert_difference('Record.count', -1) do
      delete :delete, id: @repo1.token, record_id: @record1_2.token
      assert_redirected_to(:controller => 'repositories', :action => 'show', :id => @repo1.token)
      assert (not exists_token? @record1_2.token)
    end
  end

  test 'should not delete file' do
    assert_no_difference('Record.count') do

      # No match between repository and record
      delete :delete, id: @repo2.token, record_id: @record1_2.token
      assert_redirected_to(:controller => 'repositories', :action => 'authenticate', :id => @repo2.token)
      assert exists_token? @record1_2.token

      # No match between repository and record
      delete :delete, id: @repo1.token, record_id: @record2_1.token
      assert_redirected_to(:controller => 'repositories', :action => 'show', :id => @repo1.token)
      assert exists_token? @record2_1.token

      # No session
      delete :delete, id: @repo2.token, record_id: @record2_2.token
      assert_redirected_to(:controller => 'repositories', :action => 'authenticate', :id => @repo2.token)
      assert exists_token? @record2_2.token
    end
  end

  test 'should upload file' do
    assert_difference('Record.count') do
      put :create, {id: @repo1.token, :file => fixture_file_upload('assets/foobar1.pdf','application/pdf')}
      assert_response :redirect
      assert_nil flash[:alert]
      assert_redirected_to(:controller => 'repositories', :action => 'show', :id => @repo1.token)
    end
  end

  test 'should not upload file' do
    assert_no_difference('Record.count') do

      # Invalid filename
      put :create, {id: @repo1.token, :file => fixture_file_upload('assets/invalid!@.txt','application/txt')}
      assert_not_nil flash[:alert]
      assert_redirected_to(:controller => 'repositories', :action => 'show', :id => @repo1.token)

      # No session
      put :create, {id: @repo2.token, :file => fixture_file_upload('assets/foobar1.pdf','application/pdf')}
      assert_redirected_to(:controller => 'repositories', :action => 'authenticate', :id => @repo2.token)
    end
  end
end