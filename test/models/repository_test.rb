require 'test_helper'

class RepositoryTest < ActiveSupport::TestCase

  test 'repository attributes should not be empty' do
    repo = Repository.new
    assert repo.invalid?
    assert repo.errors[:title].any?
    assert repo.errors[:password].any?
  end

  test 'repository default constructor' do
    repo = Repository.new(:title => 'Test', :password => '!s#fc*AcVB_')
    assert repo.valid?
  end

  test 'repository password should not be weak' do
    repo = Repository.new(:title => 'Test', :password => '123')
    assert repo.invalid?
    assert repo.errors[:password].any?
  end

  test 'repository token should not be equal' do
    repo = Repository.new(title: 'Test', password: '!s#fc*AcVB_', token: repositories(:one).token)
    assert repo.invalid?
    assert repo.errors[:token].any?
  end

  test 'repository invalid title' do
    repo = Repository.new(title: 'Test', password: '!s#fc*AcVB_',)
    assert repo.valid?

    repo.title = 'Invalid_!@#$%^'
    assert repo.invalid?
    assert repo.errors[:title].any?

    repo.title = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
    assert repo.invalid?
    assert repo.errors[:title].any?

    repo.title = 'Foobar 12345! Foobar_2'
    assert repo.valid?
  end

  test 'repository invalid description' do
    repo = Repository.new(title: 'Test', description: 'foobar', password: '!s#fc*AcVB_',)
    assert repo.valid?

    repo.description = 'Invalid_!@#$%^'
    assert repo.invalid?
    assert repo.errors[:description].any?

    repo.description = 'Foobar 12345! Foobar_2'
    assert repo.valid?
  end
end
