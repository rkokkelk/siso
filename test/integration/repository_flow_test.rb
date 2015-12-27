require 'test_helper'

class RepositoryFlowTest < ActionDispatch::IntegrationTest

  test 'create repository and upload files with static values' do
    open_session do |session|

      title = 'Foobar12345'
      pass = ')O(I*U&Y^T%R$E#W@Q!'
      desc = 'This is a very long description'

      https!

      get_via_redirect('/')
      assert_template 'repositories/new'

      assert_difference('Repository.count') do
        post_via_redirect('/repositories', :repository => {:description => desc, :password => pass, :password_confirm => pass, :title => title})
      end
      assert_select 'h2#header', title
      assert_select 'p.description', desc

      repo_id = Repository.last.token

      assert_difference('Record.count') do
        put_via_redirect("/repositories/#{repo_id}/record/", :file => fixture_file_upload('test/fixtures/assets/foobar1.pdf','application/pdf'))
      end

      #assert_select 'table' do
      #  assert_select 'tr' do
      #    assert_select 'td:first', 'foobar1.pdf'
      #  end
      #end
    end
  end
end
