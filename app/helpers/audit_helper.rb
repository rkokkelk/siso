require 'logger'

module AuditHelper

  @@logs = Hash.new

  def audit_log(token, audit)
    ip = request.ip
    date = DateTime.now
    message = "[%s] (%s) %s\n" % [date.to_s(:date_time), ip, audit]

    @@logs[token] ||= create_audit_log token
    @@logs[token] << message
    logger.info{"(#{token}) #{audit}"}
  end

  def read_logs(token)
    path = generate_path token
    raise Exception, 'Cannot find log' unless File.exist?(path)

    File.open(path, 'r').read
  end

  private
  def create_audit_log(token)
    path = generate_path token
    file = File.open(path, 'a')
    file.sync = true
    Logger.new(file)
  end

  def generate_path(token)
    filename = 'audit_%s.log' % token
    Rails.root.join('log', filename)
  end
end
