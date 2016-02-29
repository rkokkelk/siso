require 'logger'

module AuditHelper

  @logs ||= Hash.new

  def audit_log(token, audit)
    ip = request.ip
    date = DateTime.now
    message = "[%s] (%s) %s\n" % [date.to_s(:date_time), ip, audit]

    log = get_log token
    log << message
    log.close
  end

  def read_logs(token)
    path = generate_path token
    raise Exception, 'Cannot find log' unless File.exists?(path)

    File.open(path, 'r').read
  end

  private
  def get_log(token)
    @logs ||= Hash.new

    log = @logs[token]
    if log.nil?
      log = create_audit_log token
      @logs[token] = log
    else
      log.reopen
    end
    log
  end

  def create_audit_log(token)
    path = generate_path token
    file = File.open(path, 'a')
    Logger.new(file)
  end

  def generate_path(token)
    filename = 'audit_%s.log' % token
    Rails.root.join('log', filename)
  end
end
