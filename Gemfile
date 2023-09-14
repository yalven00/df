source 'http://rubygems.org'

if RUBY_VERSION =~ /1.9/
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

gem 'rails', '3.0.6'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'simple_form'
gem 'dynamic_form'
gem 'formtastic',  "<= 1.2.4"
gem 'httparty'
gem 'hashie'
gem 'jquery-rails', '>= 0.2.6'
gem 'geokit-rails3'
gem 'geokit'
gem "aws-ses", "~> 0.3.2", :require => 'aws/ses'
gem 'validates_timeliness', '~> 3.0.2'
gem 'rest-client'
gem 'activeadmin', '0.3.1'
gem 'roo'

# judge for form validation
gem "judge", "~> 1.5.0"


gem 'resque', :require => "resque/server"
gem "resque-retry"
gem 'resque-scheduler', :require => 'resque_scheduler'

gem 'foreman'
gem 'uuidtools'
gem 'yaml_db'#, :git => 'git://github.com/eadz/yaml_db.git'
gem 'sqlite3'
gem 'sqlite3-ruby'
gem 'rake',  '0.9.2'
gem 'tzinfo', '0.3.30'
gem 'googlecharts'
gem 'capistrano'
gem 'rvm-capistrano'
gem 'capistrano_colors'

gem 'geocoder'

group :development do
  gem 'mysql2', '< 0.3'
  gem 'jazz_hands'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'meta_request'
end

group :staging, :production do
  gem 'smurf'
  gem 'mysql2', '< 0.3'
  gem 'memcache-client'
  gem 'exception_notification', :require => 'exception_notifier'
end

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
#gem 'capistrano'
#gem 'capistrano-ext'

#gem 'rmagick'
gem 'carrierwave'
gem 'mini_magick'
gem 'flash_cookie_session'
gem 'fog'
gem 'whenever'
# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
 #gem 'ruby-debug'
 #gem 'ruby-debug19'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'
#
gem 'savon'
gem 'rails-footnotes', '>= 3.7.5.rc4', :group => :development

gem 'capistrano-recipes'
