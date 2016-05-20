require 'test_helper'

class RecordTest < ActiveSupport::TestCase
  include CryptoHelper
  include RecordsHelper

  setup do
    # Copy record files to data folder
    FileUtils.cp(Dir.glob('test/fixtures/assets/*.file'), 'data/')
  end

  test 'record attributes should not be empty' do
    record = Record.new
    assert record.invalid?
    assert record.errors[:file_name].any?
  end

  test 'record default constructor' do
    record = Record.new(file_name: 'foobar.txt', size: '10', key: generate_key)
    assert record.valid?

    record = Record.new(file_name: 'foobar.1.5.2-version(1).txt', size: '123456789', key: generate_key)
    assert record.valid?
  end

  test 'record token should not be equal' do
    record = Record.new(file_name: records(:repo1_one).file_name, token: records(:repo1_one).token, key: generate_key)
    assert record.invalid?
    assert record.errors[:token].any?
  end

  test 'record invalid file_name' do
    record = Record.new(file_name: 'foobar.txt', size: '10', token: generate_token, key: generate_key)
    assert record.valid?

    record.file_name = 'Invalid_!@<>#$%^'
    assert record.invalid?
    assert record.errors[:file_name].any?

    record.file_name = 'a.aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
    assert record.invalid?
    assert record.errors[:file_name].any?
  end

  test 'record invalid size' do
    record = Record.new(file_name: 'foobar.txt', size: '10', key: generate_key)
    assert record.valid?

    record.size = -1
    assert record.invalid?
    assert record.errors[:size].any?
  end

  test 'record removes file during destroy' do
    record = records(:repo1_one)
    token = record.token
    record.destroy

    assert !exists_token?(token)
  end
end
