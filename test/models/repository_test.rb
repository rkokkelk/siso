require 'test_helper'

class RepositoryTest < ActiveSupport::TestCase
  include RecordsHelper

  setup do
    # Copy record files to data folder
    FileUtils.cp(Dir.glob('test/fixtures/assets/*.file'), 'data/')
  end

  test 'repository attributes should not be empty' do
    repo = Repository.new
    assert repo.invalid?
    assert repo.errors[:title].any?
    assert repo.errors[:password].any?
  end

  test 'repository default constructor' do
    repo = Repository.new(title: 'Test', password: '!s##_!%fc*AcVB_')
    assert repo.valid?
  end

  test 'repository password should not be weak' do
    repo = Repository.new(title: 'Test', password: '123')
    assert repo.invalid?
    assert repo.errors[:password].any?
  end

  test 'repository token should not be equal' do
    repo = Repository.new(title: 'Test', password: '!s##_!%fc*AcVB_', token: repositories(:one).token)
    assert repo.invalid?
    assert repo.errors[:token].any?
  end

  test 'repository invalid title' do
    repo = Repository.new(title: 'foobar', password: '!s##_!%fc*AcVB_')
    assert repo.valid?

    repo.title = 'Invalid_!@#$%^'
    assert repo.invalid?
    assert repo.errors[:title].any?

    repo.title = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
    assert repo.invalid?
    assert repo.errors[:title].any?
  end

  test 'repository invalid description' do
    repo = Repository.new(title: 'Test', description: 'foobar', password: '!s##_!%fc*AcVB_')
    assert repo.valid?

    repo.description = 'Invalid_!@#$%^'
    assert repo.invalid?
    assert repo.errors[:description].any?
  end

  test 'should destroy records of repository during destroy' do
    tokens = []
    repo = repositories(:one)
    repo_records = Record.where('repositories_id = ?', repo.id)

    repo_records.each do |record|
      tokens << record.token
    end

    assert_difference('Repository.count', -1) do
      assert_difference('Record.count', (-tokens.size)) do
        repo.destroy
      end
    end

    # Verify that all data files are deleted
    tokens.each do |token|
      assert !exists_token?(token)
    end
  end
end
