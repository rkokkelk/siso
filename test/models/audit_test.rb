require 'test_helper'

class AuditTest < ActiveSupport::TestCase
  setup do
    @audit1_1 = audits(:audit1_one)
    @audit2_1 = audits(:audit2_one)
  end

  test 'audit message should be valid' do
    audit = Audit.new(token: '0e9d87d5bcb7e254f591a2e374bd94ba', message: 'foobar')
    assert audit.valid?
  end

  test 'audit message should be invalid' do
    audit = Audit.new(token: '0e9d87d5bcb7e254f591a2e374bd94ba', message: 'foobar!@#$%*()')
    assert audit.invalid?
  end
end
