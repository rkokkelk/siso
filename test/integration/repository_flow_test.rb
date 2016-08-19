require 'test_helper'

class RepositoryFlowTest < ActionDispatch::IntegrationTest
  test 'create repository and upload files with static values' do
    sess = create_session
    sess.redirect_new
    sess.init_values
    sess.create_repo
    sess.upload_file
    sess.download_file
    sess.delete_file
  end

  test 'create repository and upload files with guest access' do
    creator = create_session
    guest = create_session

    creator.init_values
    guest.init_values

    creator.redirect_new
    creator.create_repo

    guest.repository = creator.repository
    guest.authenticate

    guest.show_repo
    creator.show_repo

    guest.upload_file
    creator.record = guest.record

    guest.show_repo
    creator.show_repo

    creator.download_file
    guest.download_file

    guest.show_repo
    creator.show_repo

    creator.delete_file

    guest.show_audit
    creator.show_audit

    guest.show_repo
    creator.show_repo
  end

  test 'create repository and upload files with random values' do
    title = generate_titles
    pass = ')O(I*U&Y^T%R$E#W@Q!'
    desc = generate_description

    https!

    get_via_redirect('/')
    assert_template 'repositories/new'

    assert_difference('Repository.count') do
      assert_difference('Audit.count') do
        post_via_redirect('/new', repository: { description: desc, password: pass, password_confirmation: pass, title: title })
      end
    end

    assert_select 'h2#header', title
    assert_select 'p.description', desc
    assert_select 'table td:nth-child(1)', 'No records'
  end

  private

  def create_session
    open_session do |sess|
      sess.https!
      sess.extend(RepositorySessionDSL)
    end
  end

  module RepositorySessionDSL
    def init_values(desc = 'This is a very long description', pass = ')O(I*U&Y^T%R$E#W@Q!', title = 'Foobar12345')
      @desc = desc
      @pass = pass
      @title = title
    end

    def redirect_new
      get_via_redirect('/')
      assert_template 'repositories/new'
    end

    def create_repo
      assert_difference('Repository.count') do
        assert_difference('Audit.count') do
          post_via_redirect('/new', repository: { description: @desc, password: @pass, password_confirmation: @pass, title: @title })
        end
      end
      assert_template 'repositories/show'
      @repo = Repository.last
    end

    def authenticate
      get "/#{@repo.token}"
      assert_redirected_to "/#{@repo.token}/authenticate"

      post "/#{@repo.token}/authenticate", password: @pass
      assert_redirected_to "/#{@repo.token}"
    end

    def show_repo
      get "/#{@repo.token}"

      @records = Record.where(repositories_id: @repo.id)

      assert_select 'h2#header', @title
      assert_select 'p.description', @desc

      if @records.size == 0
        assert_select 'table td:nth-child(1)', 'No records'
      else
        assert_select 'table td:nth-child(1)' do |cells|
          assert_equal cells.size, @records.size
          cells.each do |cell|
            assert_select cell, 'a', text: 'foobar1.pdf'
          end
        end
      end
    end

    def show_audit
      get "/#{@repo.token}/audit"
      assert_select 'p.logs', /[\w\d\s\[\]()]+/
    end

    def upload_file
      assert_difference('Record.count') do
        put_via_redirect("/#{@repo.token}/record/", file: fixture_file_upload('test/fixtures/assets/foobar1.pdf', 'application/pdf'))
      end
      @record = Record.last
    end

    def download_file
      get "/#{@repo.token}/#{@record.token}"
      assert_equal response.body, IO.binread('test/fixtures/assets/foobar1.pdf')
    end

    def delete_file
      # Verify if data can be deleted
      assert_difference('Record.count', -1) do
        delete_via_redirect("/#{@repo.token}/#{@record.token}")
      end
    end

    def repository
      @repo
    end

    def repository=(repo)
      @repo = repo
    end

    def record
      @record
    end

    def record=(record)
      @record = record
    end
  end
end
