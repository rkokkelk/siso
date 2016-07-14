# Be sure to restart your server when you modify this file.
# Rufus-Scheduler configuration file

require 'rufus-scheduler'
include AuditHelper
include RepositoriesHelper

# Generate Scheduler Singleton
s = Rufus::Scheduler.singleton

s.every '2h' do
  Rails.logger.debug { "Running cleanup repo's" }
  RepositoriesHelper.clear_old_repositories
  AuditHelper.clear_old_audit_logs
end