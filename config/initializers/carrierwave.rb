CarrierWave.configure do |config|
  # config.fog_credentials = {
  #   provider:                         'Google',
  #   google_storage_access_key_id:     Rails.application.secrets.google_storage_access_key_id,
  #   google_storage_secret_access_key: Rails.application.secrets.google_storage_secret_access_key
  # }
  #
  # config.fog_directory = 'gaffer-images'

  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => Rails.application.secrets.amazon_s3_access_key_id,
    :aws_secret_access_key  => Rails.application.secrets.amazon_s3_secret_access_key,
    # :region                 => 'us-standard' # Change this for different AWS region. Default is 'us-east-1'
  }
  config.fog_directory  = "gaffer-images"

end
