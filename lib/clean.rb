#!/usr/bin/env ruby
require 'pathname'
require 'fileutils'

include RepositoriesHelper
include RecordsHelper
include AuditHelper

# path to your application root.
APP_ROOT = Pathname.new File.expand_path('../../',  __FILE__)

Dir.chdir APP_ROOT do
  puts '== Removing outdated repositories =='
  RepositoriesHelper.clear_old_repositories

  puts '== Removing old audit logs =='
  AuditHelper.clear_old_audit_logs

  puts '== Finding orphaned records =='
  remove_records = []
  data_dir = APP_ROOT.join('data/')
  records = Dir.glob(data_dir.join('*.file'))

  records.each do |record|
    token = RecordsHelper.get_token record
    remove_records.append(token) unless Record.exists?(token: token)
  end

  if remove_records.size > 0
    puts format('%d orphaned record(s) found', remove_records.size)
    puts 'Remove orphaned records [y/n]'
    inp = gets.chomp
    inp = inp.downcase
    if inp == 'y' || inp == 'yes'
      remove_records.each do |record|
        RecordsHelper.remove_record record
      end
      puts format('Removed %d records', remove_records.size)
    end
  end
end
