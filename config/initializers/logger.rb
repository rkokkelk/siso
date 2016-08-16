# Be sure to restart your server when you modify this file.
# Define logger and format

Rails.logger = Logger.new('/dev/null')

unless Rails.env.development?
  case Rails.configuration.x.config['LOGGER']
    when 'stdout'
      Rails.logger = Logger.new(STDOUT)
    when 'file'
      Rails.logger = Logger.new("#{Rails.root}/log/#{Rails.env}.log")
  end
end

Rails.logger.formatter = proc { |severity, datetime, progname, msg|
  format("%s [%-5s] %s%s\n",
         datetime.to_s(:logging),
         severity,
         progname ? "#{progname} -- " : nil,
         msg)
}

