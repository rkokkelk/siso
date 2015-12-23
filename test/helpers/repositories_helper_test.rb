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

    assert (not exists_token? 'cf678794afe813f56170e092fb217f61')
    assert (not exists_token? 'a170edeaa8eeb4c3749ccb9b3f69468f')
  end
end
