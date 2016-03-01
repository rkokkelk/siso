require 'test_helper'

class RepositoriesHelperTest < ActiveSupport::TestCase
  include RepositoriesHelper
  include RecordsHelper

  setup do
    # Copy record files to data folder
    FileUtils.cp(Dir.glob('test/fixtures/assets/*.file'),'data/')
  end

  test 'should remove repository when old' do
    assert_difference('Repository.count', -1) do
      assert_difference('Record.count',-2) do
        clear_old_repositories
      end
    end

    assert (not exists_token? '7cb79fc60c4d15a68fc5d94008c1f128')
    assert (not exists_token? '0ef32b37113953c02229b7b3c48ce2f8')
  end
end
