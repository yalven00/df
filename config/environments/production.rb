Dealsformommy::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  REVISION = File.exists?('REVISION') ? %x{cat REVISION | cut -c -7}.rstrip : false

  config.action_controller.asset_path = proc do |asset_path|
   if asset_path =~ /^\/images\//
    "/release-#{REVISION}#{asset_path}"
   else
      asset_path
   end
  end

  Dealsformommy::Application.config.middleware.use ExceptionNotifier,
    :email_prefix => "[ DFM Exception ] ",
    :sender_address => %{"DFM exception notifier" <no-reply@dealsformommy.com>},
    :exception_recipients => %w{tech@parentmediainc.com}

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  #config.cache_store = :file_store, "#{Rails.root.to_s}/tmp/cache"
  config.cache_store = :mem_cache_store, "localhost"

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_assets = false

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://media.dealsformommy.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false
  config.action_mailer.delivery_method = :ses

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
end
