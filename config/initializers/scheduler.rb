# Be sure to restart your server when you modify this file.
# Rufus-Scheduler configuration file
# ToDo: Ensure proper implementation with Phusion

require 'rufus-scheduler'
include RepositoriesHelper

# Generate Scheduler Singleton
s = Rufus::Scheduler.singleton

s.every '6h' do
  Rails.logger.debug{'Running cleanup repo\'s'}
  RepositoriesHelper.clear_old_repositories
end

