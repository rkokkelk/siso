require 'test_helper'

class RepositoryFlowTest < ActionDispatch::IntegrationTest

  test 'create repository and upload files with static values' do

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
    assert_select 'table td:nth-child(1)', 'No records'

    repo = Repository.last
    assert_difference('Record.count') do
      put_via_redirect("/repositories/#{repo.token}/record/", :file => fixture_file_upload('test/fixtures/assets/foobar1.pdf','application/pdf'))
    end
    record = Record.last

    get "/repositories/#{repo.token}"
    @records = Record.where(repositories_id: repo.id)

    assert_select 'table td:nth-child(1)', {:count => @records.size}
    assert_select 'table td:nth-child(1)' do |cells|
      cells.each do |cell|
        assert_select cell, 'a', {:text => 'foobar1.pdf'}
      end
    end

    assert_difference('Record.count', -1) do
      delete_via_redirect("/repositories/#{repo.token}/record/#{record.token}")
    end

    get "/repositories/#{repo.token}"
    assert_select 'table td:nth-child(1)', 'No records'
  end
end
