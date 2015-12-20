require 'test_helper'

class RepositoryTest < ActiveSupport::TestCase

  test 'repository attributes should not be empty' do
    repo = Repository.new
    assert repo.invalid?
    assert repo.errors[:title].any?
    assert repo.errors[:password].any?
  end

  test 'repository default constructor' do
    repo = Repository.new(:title => 'Test', :password => '!s##_!%fc*AcVB_')
    assert repo.valid?
  end

  test 'repository password should not be weak' do
    repo = Repository.new(:title => 'Test', :password => '123')
    assert repo.invalid?
    assert repo.errors[:password].any?
  end

  test 'repository token should not be equal' do
    repo = Repository.new(title: 'Test', password: '!s##_!%fc*AcVB_', token: repositories(:one).token)
    assert repo.invalid?
    assert repo.errors[:token].any?
  end

  test 'repository invalid title' do
    repo = Repository.new(title: 'foobar', password: '!s##_!%fc*AcVB_',)
    assert repo.valid?

    repo.title = 'Invalid_!@#$%^'
    assert repo.invalid?
    assert repo.errors[:title].any?

    repo.title = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
    assert repo.invalid?
    assert repo.errors[:title].any?
  end

  test 'repository invalid description' do
    repo = Repository.new(title: 'Test', description: 'foobar', password: '!s##_!%fc*AcVB_',)
    assert repo.valid?

    repo.description = 'Invalid_!@#$%^'
    assert repo.invalid?
    assert repo.errors[:description].any?
  end
end
