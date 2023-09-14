# config/initializers/load_config.rb
APP_CONFIG = YAML.load_file("#{Rails.root.to_s}/config/config.yml")[Rails.env]

Groupon.configure do |config|
  config.api_key = APP_CONFIG['groupon_api_key']
end