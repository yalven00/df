
CarrierWave.configure do |config|
  if Rails.env.production? || true
    config.storage = :file
=begin
    config.fog_credentials = {
      :provider               => 'AWS',       # required
      :aws_access_key_id      => '',       # copied off the aws site
      :aws_secret_access_key  => '',       # 
    }
    config.fog_directory  = 'coregs'                     # required
    config.fog_public     = true                                   # optional, defaults to true
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
    
    config.storage = :s3
    config.s3_access_key_id = ''
    config.s3_secret_access_key = ''
    config.s3_bucket = 's3.canvaspeople.com'
    config.s3_access = :public_read
    config.s3_headers = {'Cache-Control' => 'max-age=315576000', 
       'Expires' => 99.years.from_now.httpdate}
=end
  elsif Rails.env.development?
    config.storage = :file
  else
    config.storage = :file
  end
end


