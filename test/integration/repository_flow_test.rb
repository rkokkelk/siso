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

  test 'do not show new repository when originating from invalid IP' do
    # Perform get request from unauthenticated IP
    get('/', nil, {'REMOTE_ADDR' => '::1'})
    assert_response :success
    assert_template 'main/index'
  end

  test 'create repository and upload files with guest access' do

    creator = create_session
    guest = create_session

    creator.init_values
    guest.init_values

    creator.redirect_new
    creator.create_repo

    guest.set_repository creator.get_repository
    guest.authenticate

    guest.show_repo
    creator.show_repo

    guest.upload_file
    creator.set_record guest.get_record

    guest.show_repo
    creator.show_repo

    creator.download_file
    guest.download_file

    guest.show_repo
    creator.show_repo

    creator.delete_file

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
      post_via_redirect('/repositories/new', :repository => {:description => desc, :password => pass, :password_confirm => pass, :title => title})
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

    def init_values(desc = 'This is a very long description', pass=')O(I*U&Y^T%R$E#W@Q!', title='Foobar12345')
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
        post_via_redirect('/repositories/new', :repository => {:description => @desc, :password => @pass, :password_confirm => @pass, :title => @title})
      end
      assert_template 'repositories/show'
      @repo = Repository.last
    end

    def authenticate
      get "/repositories/#{@repo.token}"
      assert_redirected_to "/repositories/#{@repo.token}/authenticate"

      post "/repositories/#{@repo.token}/authenticate", :password => @pass
      assert_redirected_to "/repositories/#{@repo.token}"
    end

    def show_repo
      get "/repositories/#{@repo.token}"

      @records = Record.where(repositories_id: @repo.id)

      assert_select 'h2#header', @title
      assert_select 'p.description', @desc

      if @records.size == 0
        assert_select 'table td:nth-child(1)', 'No records'
      else
        assert_select 'table td:nth-child(1)' do |cells|
          assert_equal cells.size, @records.size
          cells.each do |cell|
            assert_select cell, 'a', {:text => 'foobar1.pdf'}
          end
        end
      end
    end

    def upload_file
      assert_difference('Record.count') do
        put_via_redirect("/repositories/#{@repo.token}/record/", :file => fixture_file_upload('test/fixtures/assets/foobar1.pdf','application/pdf'))
      end
      @record = Record.last
    end

    def download_file
      get "/repositories/#{@repo.token}/record/#{@record.token}"
      assert_equal response.body, IO.binread('test/fixtures/assets/foobar1.pdf')
    end

    def delete_file
      # Verify if data can be deleted
      assert_difference('Record.count', -1) do
        delete_via_redirect("/repositories/#{@repo.token}/record/#{@record.token}")
      end
    end

    def get_repository
      @repo
    end

    def set_repository(repo)
      @repo = repo
    end

    def get_record
      @record
    end

    def set_record(record)
      @record = record
    end
  end
end
