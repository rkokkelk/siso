require 'test_helper'

class RecordsFlowTest < ActionDispatch::IntegrationTest
  fixtures :all

  test 'multiple file upload and download actions' do

    @repo1 = repositories(:one)

    post "/#{@repo1.token}/authenticate", password: ')O(I*U&Y%R$E'
    assert_redirected_to "/#{@repo1.token}"

    get "/#{@repo1.token}"
    assert_select 'h2#header', @repo1.title
    assert_select 'p.description', @repo1.description

    # Upload and download files, 100 times
    # Todo: make file content and name random
    num_actions = 20
    assert_difference('Record.count', num_actions) do
      num_actions.times do
        put_via_redirect("/#{@repo1.token}/record/", file: fixture_file_upload('test/fixtures/assets/foobar1.pdf', 'application/pdf'))
        tmp_record = Record.last
        get "/#{@repo1.token}/#{tmp_record.token}"
        assert_equal response.body, IO.binread('test/fixtures/assets/foobar1.pdf')
      end
    end
  end
end
