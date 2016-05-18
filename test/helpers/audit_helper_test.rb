require 'test_helper'

class RepositoriesHelperTest < ActiveSupport::TestCase
  include CryptoHelper
  include AuditHelper

  test 'set new deletion date' do
    @repo2 = repositories(:two)
    update_end_date_audit_logs @repo2.token

    correct_date = DateTime.now >> 3
    audits = Audit.where(token: @repo2.token)
    audits.each do |audit|
      assert_equal(audit.deletion, correct_date.to_date)
    end
  end

  test 'clear old audit logs' do
    assert_difference('Audit.count', -2) do
      clear_old_audit_logs
    end
  end
end
