require 'test_helper'

class RecordTest < ActiveSupport::TestCase

  include CryptoHelper

  test 'record attributes should not be empty' do
    record = Record.new
    assert record.invalid?
    assert record.errors[:file_name].any?
  end

  test 'record default constructor' do
    record = Record.new(:file_name => 'foobar.txt')
    assert record.valid?
  end

  test 'record token should not be equal' do
    record = Record.new(file_name: record(:one).file_name, token: record(:one).token)
    assert record.invalid?
    assert record.errors[:token].any?
  end

  test 'record invalid file_name' do
    record = Record.new(file_name: 'foobar.txt', token: generate_token)
    assert record.valid?

    record.title = 'Invalid_!@<>#$%^'
    assert record.invalid?
    assert record.errors[:file_name].any?

    record.title = 'a.aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
    assert record.invalid?
    assert record.errors[:file_name].any?
  end

  test 'record invalid size' do
    record = Record.new(file_name: 'foobar.txt', size: 10)
    assert record.valid?

    record.size = -1
    assert record.invalid?
    assert record.errors[:size].any?
  end
end
