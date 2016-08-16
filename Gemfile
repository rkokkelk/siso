source 'https://rubygems.org'

# BCrypt module
gem 'bcrypt', '~> 3.1.2'
# PBKDF2 module
gem 'pbkdf2', '~> 0.1.0'
# Mime-Types gem, used to determine mime-types of extensions
gem 'mime-types'
# NetAddr used for IP whitelist
gem 'netaddr', '~> 1.5'
# Password strength validator
gem 'strong_password', '~> 0.0.5'
# Rack Attack middleware. Against brute-force attack, etc
gem 'rack-attack'
# Cron gemfile
gem 'rufus-scheduler', '~> 3.1', '>= 3.1.10'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.7.1'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# Ensure that Nokogiri is updated to at least 1.6.8 due to libxml2 vulnerability
gem 'nokogiri', '~> 1.6', '>= 1.6.8'

# Lograge gem for diminishing Rails standard output
gem 'lograge'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

group :heroku do
  # Use postgres as the database for Active Record
  gem 'pg'
end

group :test do
  # Use codeclimate to show code coverage
  gem 'codeclimate-test-reporter', require: nil
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :production, :development, :test do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

