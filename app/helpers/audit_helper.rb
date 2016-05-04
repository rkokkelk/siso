require 'logger'

module AuditHelper

  def audit_log(token, audit)
    ip = request.ip
    date = DateTime.now
    message = '[%s] (%s) %s' % [date.to_s(:date_time), ip, audit]

    @audit = Audit.new(:token => token, :message => message, :deletion => date >> 2)
    raise Exception, '[%s] Cannot store audit log' % token unless @audit.save

    logger.info{"(#{token}) #{audit}"}
  end

  def set_end_date_audit_logs(token)
    # Logs are available for three months after deletion of repository
    end_date = DateTime.now >> 3

    @audits = Audit.where(token: token)
    @audits.each do |audit|
      audit.update(deletion: end_date)
    end
  end

  def clear_old_audit_logs
    Audit.delete_all(['deletion <= ?', DateTime.now])
    Rails.logger.debug{'Deleted old audit logs'}
  end
end