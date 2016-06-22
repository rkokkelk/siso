# Be sure to restart your server when you modify this file.
# Rufus-Scheduler configuration file

require 'rufus-scheduler'
include AuditHelper
include RepositoriesHelper

# Execute cleanup at startup of SISO
# not using in test due to DB creation errors
unless Rails.env.test?
  clear_old_repositories
  clear_old_audit_logs
end

# Generate Scheduler Singleton
s = Rufus::Scheduler.singleton

s.every '2h' do
  Rails.logger.debug { "Running cleanup repo's" }
  RepositoriesHelper.clear_old_repositories
  AuditHelper.clear_old_audit_logs
end