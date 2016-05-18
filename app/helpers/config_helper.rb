require 'yaml'

module ConfigHelper
  CONFIG_LOC = 'config/config.yml'
  APP_CONFIG = YAML.load_file(Rails.root.join(CONFIG_LOC))

  # Get config value
  # ENV takes precedent over config file
  def get_config(key)
    result = ENV[key] || APP_CONFIG[key]

    return result if result
    raise Exception, "No value found with #{key}"
  end
end
