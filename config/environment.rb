# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Define logger and format
Rails.logger = Logger.new(STDOUT)
Rails.logger.formatter = proc { |severity, datetime, progname, msg|
  format("%s [%-5s] %s%s\n",
         datetime.to_s(:logging),
         severity,
         progname ? "#{progname} -- " : nil,
         msg)
}

# Initialize the Rails application.
Rails.application.initialize!