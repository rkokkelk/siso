# Be sure to restart your server when you modify this file.
# Define logger and format

case Rails.configuration.x.config['LOGGER']
  when 'stdout'
    logger = Logger.new(STDOUT)
  when 'file'
    logger = Logger.new("#{Rails.root}/log/#{Rails.env}.log")
end

# Set log level
logger.level = Rails.configuration.x.config['LOG_LEVEL']

# Set enviroment specific settings
if Rails.env.development?
  logger = Logger.new('/dev/null')
  logger.level = :debug
elsif Rails.env.heroku?
  logger = Logger.new(STDOUT)
  logger.level = :info
end

logger.formatter = proc { |severity, datetime, progname, msg|
  format("%s [%-5s] %s%s\n",
         datetime.to_s(:logging),
         severity,
         progname ? "#{progname} -- " : nil,
         msg)
}

Rails.logger = logger

Siso::Application.configure do
  # Set lograge enabled, improves Rails standard output
  config.lograge.enabled = true
end

